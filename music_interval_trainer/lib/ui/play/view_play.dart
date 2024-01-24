import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/play_timer.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/widget_play_challenge_panel.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/widget_play_countdown.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/widget_play_info_panel.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/widget_play_toolbar.dart';

import '../../common/environment/application_state.dart';
import '../../common/environment/settings_manager.dart';
import '../../common/utils/constants.dart';
import '../../logic/engine/play_engine.dart';

class ViewPlay extends StatefulWidget {
  const ViewPlay({super.key});

  @override
  ViewPlayState createState() => ViewPlayState();
}

class ViewPlayState extends State<ViewPlay> {
  late ApplicationState _applicationState;
  DateTime? _partialElapsedTime;
  final SettingsManager _settingsManager = SettingsManager();

  PlayEngine? _playEngine;
  PlayTimer? _playTimer;

  final GlobalKey<WidgetPlayCountDownState> _countDownWidgetKey = GlobalKey();
  final GlobalKey<WidgetPlayInfoPanelState> _infoPanelWidgetKey = GlobalKey();
  final GlobalKey<WidgetPlayToolbarState> _toolbarWidgetKey = GlobalKey();

  final _intervalValueNotifier = ValueNotifier<String>(Constants.unsetValue);
  final _keyValueNotifier = ValueNotifier<String>(Constants.unsetValue);

  final CountDownController _countDownController = CountDownController();
  final int _countDownDuration = 3 + 1 /* Compensate widget showing delay */;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            WidgetPlayChallengePanel(
              intervalValueNotifier: _intervalValueNotifier,
              keyValueNotifier: _keyValueNotifier,
            ),
            WidgetPlayInfoPanel(
              key: _infoPanelWidgetKey,
              intervalsCount: ((null != _playEngine) ? _playEngine!.intervalsCount : 0),
              keysCount: ((null != _playEngine) ? _playEngine!.keysCount : 0),
            ),
          ],
        ),
        WidgetPlayToolbar(
          key: _toolbarWidgetKey,
          onPause: _onPausePressed,
          onResume: _onResumePressed,
          onStart: _onStartPressed,
          onStop: _onStopPressed,
        ),
        WidgetPlayCountDown(
          key: _countDownWidgetKey,
          controller: _countDownController,
          duration: _countDownDuration,
          onComplete: _onCountDownComplete,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _applicationState.unregister();
    super.dispose();
  }

  void initialize() {
    _settingsManager.load(
      () => setState(() {
        _initializePlayEngine();
        _initializeTimer();

        // Then refresh UI with loaded settings...
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    _applicationState = ApplicationState(
      _onApplicationActivate,
      _onApplicationDeactivate,
    );

    _applicationState.register();

    initialize();
  }

  void stop(VoidCallback setStateCallback) {
    if (WidgetPlayToolbarStatus.running == _toolbarWidgetKey.currentState!.status) {
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

  void doNextChallenge() {
    if (null != _playEngine) {
      var answer = _playEngine!.next();
      _intervalValueNotifier.value = answer.interval;

      if (_settingsManager.keysActive) {
        _keyValueNotifier.value = answer.key;
      }
    }
  }

  void _doPlay(bool resume) {
    setState(() {
      _stopCountDown();
      _resetElapsedTimeSegment();

      if (!resume) {
        _intervalValueNotifier.value = Constants.unsetValue;
        _keyValueNotifier.value = Constants.unsetValue;
        _infoPanelWidgetKey.currentState!.reset();
      }

      _startCountDown();
    });
  }

  void _doStop() {
    setState(() {
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

    _playTimer = PlayTimer(
      Duration(
        milliseconds: (_settingsManager.intervalsQuantum / SettingsManager.intervalsSpeedFactor * 1000).toInt(),
      ),
      true,
      _onTimerElapsed,
    );
  }

  void _onApplicationActivate() {
    _toolbarWidgetKey.currentState!.resume();
  }

  void _onApplicationDeactivate() {
    _toolbarWidgetKey.currentState!.pause();
  }

  void _onCountDownComplete() {
    if (_applicationState.isActive) {
      setState(() {
        _stopCountDown();
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

  bool _onTimerElapsed(PlayTimer timer) {
    setState(() {
      doNextChallenge();
      _updateElapsedTimeTotal();
      _doFeedback();
    });

    return true;
  }

  void _resetElapsedTimeSegment() {
    _partialElapsedTime = DateTime.now();
  }

  void _startCountDown() {
    if (!_countDownWidgetKey.currentState!.isVisible) {
      _toolbarWidgetKey.currentState!.status = WidgetPlayToolbarStatus.running;
      _countDownWidgetKey.currentState!.isVisible = true;
      _countDownController.start();
    }
  }

  void _stopCountDown() {
    if (_countDownWidgetKey.currentState!.isVisible) {
      _countDownWidgetKey.currentState!.isVisible = false;
      _countDownController.reset();
    }
  }

  void _updateElapsedTimeTotal() {
    _infoPanelWidgetKey.currentState!.increment(
      DateTime.now().difference(_partialElapsedTime!),
    );

    _resetElapsedTimeSegment();
  }
}
