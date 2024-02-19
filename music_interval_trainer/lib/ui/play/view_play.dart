import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/utils/wrapper_timer.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/widget_play_challenge_panel.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/widget_play_countdown.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/widget_play_info_panel.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/widget_play_toolbar.dart';

import '../../common/environment/application_state.dart';
import '../../common/environment/configuration_manager.dart';
import '../../common/environment/settings_manager.dart';
import '../../common/ui/widget_state_async.dart';
import '../../common/utils/constants.dart';
import '../../logic/engine/play_engine.dart';

class ViewPlay extends StatefulWidget {
  final ViewPlayController controller;

  const ViewPlay({
    super.key,
    required this.controller,
  });

  @override
  ViewPlayState createState() => ViewPlayState();
}

class ViewPlayState extends WidgetStateAsync<ViewPlay> {
  late ApplicationState _applicationState;
  final Configuration _configuration = Configuration();
  DateTime? _partialElapsedTime;
  final SettingsManager _settingsManager = SettingsManager();

  PlayEngine? _playEngine;
  WrapperTimer? _playTimer;

  bool _intervalChanged = false;
  final _intervalValueNotifier = ValueNotifier<String>(Constants.unsetValue);
  final _keyValueNotifier = ValueNotifier<String>(Constants.unsetValue);

  final WidgetPlayCountDownController _countDownController = WidgetPlayCountDownController();
  final WidgetPlayInfoPanelController _infoPanelController = WidgetPlayInfoPanelController();
  final WidgetPlayToolbarController _playToolbarController = WidgetPlayToolbarController();

  @override
  void dispose() {
    _applicationState.unregister();
    super.dispose();
  }

  @override
  Widget doBuild(BuildContext context) {
    final bool keysActive = _settingsManager.keysActive;
    final int playCountdownTimeout = _configuration.playCountdownTimeout;

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            WidgetPlayChallengePanel(
              intervalValueNotifier: _intervalValueNotifier,
              intervalChanged: _intervalChanged,
              keysActive: _settingsManager.keysActive,
              keyValueNotifier: _keyValueNotifier,
            ),
            WidgetPlayInfoPanel(
              controller: _infoPanelController,
              intervalsCount: ((null != _playEngine) ? _playEngine!.intervalsCount : 0),
              keysActive: keysActive,
              keysCount: ((null != _playEngine) ? _playEngine!.keysCount : 0),
            ),
          ],
        ),
        WidgetPlayToolbar(
          controller: _playToolbarController,
          onPause: _onPausePressed,
          onResume: _onResumePressed,
          onStart: _onStartPressed,
          onStop: _onStopPressed,
        ),
        WidgetPlayCountDown(
          controller: _countDownController,
          seconds: playCountdownTimeout,
          onComplete: _onCountDownComplete,
        ),
      ],
    );
  }

  @override
  Future<void> doInitializeData() async {
    await _configuration.load(context);
    await _settingsManager.load();
  }

  @override
  void onDataInitialized() {
    setState(
      () {
        _initializePlayEngine();
        _initializeTimer();

        // Then refresh UI with loaded settings...
      },
    );
  }

  Future<void> initialize() async {
    await _configuration.load(context);
    await _settingsManager.load();

    onDataInitialized();
  }

  @override
  void initState() {
    widget.controller._state = this;

    _applicationState = ApplicationState(
      _onApplicationActivate,
      _onApplicationDeactivate,
    ).register();

    super.initState();
  }

  void stop(VoidCallback setStateCallback) {
    if (WidgetPlayToolbarStatus.running == _playToolbarController.status) {
      _doAskForStopping(setStateCallback);
    } else {
      setStateCallback();
    }
  }

  void _doAskForStopping(VoidCallback? setStateCallback) {
    _playTimer!.stop();
    _stopCountDown();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.dialogTitleWarning,
          ),
          content: Text(
            AppLocalizations.of(context)!.viewPlay_StopAlert_Message,
          ),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.buttonYes,
              ),
              onPressed: () {
                _doStop();
                Navigator.of(context).pop();

                if (null != setStateCallback) {
                  setStateCallback();
                }
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.buttonNo,
              ),
              onPressed: () {
                _startCountDown();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _doFeedback() async {
    if (_settingsManager.uxFeedbackSound) {
      FlutterBeep.beep();
    }

    if (_settingsManager.uxFeedbackVibration) {
      HapticFeedback.mediumImpact();
    }
  }

  void _doNextChallenge() {
    if (null != _playEngine) {
      var answer = _playEngine!.next();
      _intervalChanged = answer.intervalChanged;
      _intervalValueNotifier.value = answer.interval;

      if (_settingsManager.keysActive) {
        _keyValueNotifier.value = answer.key;
      }
    }
  }

  void _doPlay(bool resume) {
    setState(() {
      _stopCountDown();

      if (!resume) {
        _intervalValueNotifier.value = Constants.unsetValue;
        _keyValueNotifier.value = Constants.unsetValue;
        _infoPanelController.reset();
      }

      _startCountDown();
    });
  }

  void _doStop() {
    setState(() {
      _playToolbarController.status = WidgetPlayToolbarStatus.stopped; // Force button statu
      _playTimer!.stop();
      _stopCountDown();
      _updateElapsedTimeTotal();
    });
  }

  void _initializePlayEngine() {
    _playEngine = PlayEngine(context, _settingsManager);
  }

  void _initializeTimer() {
    if (null != _playTimer) {
      _playTimer!.stop();
    }

    _playTimer = WrapperTimer(
      Duration(
        milliseconds: (_settingsManager.intervalsQuantum / SettingsManager.intervalsSpeedFactor * 1000).toInt(),
      ),
      true,
      _onTimerElapsed,
    );
  }

  void _onApplicationActivate() {
    _playToolbarController.resume();
  }

  void _onApplicationDeactivate() {
    _playToolbarController.pause();
  }

  void _onCountDownComplete() {
    if (_applicationState.isActive) {
      setState(() {
        _stopCountDown();
        _resetElapsedTimeSegment();
        _playTimer!.start();
      });
    }
  }

  void _onPausePressed() {
    setState(() {
      _playTimer!.stop();
      _stopCountDown();
      _updateElapsedTimeTotal();
    });
  }

  void _onResumePressed() {
    _doPlay(true);
  }

  void _onStartPressed() {
    _doPlay(false);
  }

  void _onStopPressed() {
    _doAskForStopping(null);
  }

  bool _onTimerElapsed(WrapperTimer timer) {
    setState(() {
      _doNextChallenge();
      _updateElapsedTimeTotal();
      _doFeedback();
    });

    return true;
  }

  void _resetElapsedTimeSegment() {
    _partialElapsedTime = DateTime.now();
  }

  void _startCountDown() {
    if (!_countDownController.isVisible) {
      _playToolbarController.status = WidgetPlayToolbarStatus.running; // Force button status
      _countDownController.isVisible = true;
      _countDownController.start();
    }
  }

  void _stopCountDown() {
    if (_countDownController.isVisible) {
      _countDownController.isVisible = false;
      _countDownController.stop();
    }
  }

  void _updateElapsedTimeTotal() {
    _infoPanelController.increment(
      DateTime.now().difference(_partialElapsedTime!),
    );

    _resetElapsedTimeSegment();
  }
}

class ViewPlayController {
  late ViewPlayState _state;

  void initialize() => _state.initialize();

  void stop(VoidCallback setStateCallback) => _state.stop(setStateCallback);
}
