import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/play_engine.dart';

import '../../common/environment/settings_manager.dart';
import '../../common/ui/custom_icons.dart';
import '../../common/ui/fonts_catalog.dart';
import '../../common/ui/widget_blinking_text.dart';

class ViewPlay extends StatefulWidget {
  const ViewPlay({super.key});

  @override
  ViewPlayState createState() => ViewPlayState();
}

class ViewPlayState extends State<ViewPlay> with WidgetsBindingObserver {
  static const String _unsetValue = '-';

  final SettingsManager _settingsManager = SettingsManager();

  bool isApplicationActive = true;

  final int _countDownDuration = 3 + 1 /* Compensate widget showing delay */;
  bool _isCountDownVisible = false;
  final CountDownController _countDownController = CountDownController();

  final _intervalTextNotifier = ValueNotifier<String>(_unsetValue);
  final _keyTextNotifier = ValueNotifier<String>(_unsetValue);
  PlayEngine? _playEngine;

  bool _isPauseButtonEnabled = false;
  bool _isPlayButtonEnabled = true;
  bool _isStopButtonEnabled = false;

  DateTime? _infoElapsedTimeSegmentStart;
  Duration? _infoElapsedTimeTotal;

  Timer? _timer;
  Duration? _timerInterval;
  int _intervalMils = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            _buildPlayPanels(),
            _buildInfoPanel(),
          ],
        ),
        _buildToolButtonsBar(context),
        _buildCountDown(context),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        isApplicationActive = false;

        if (_isRunning()) {
          _doPause();
        }

        break;

      case AppLifecycleState.resumed:
        isApplicationActive = true;

        if (_isPaused()) {
          _doPlay();
        }

        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    reload();
    WidgetsBinding.instance.addObserver(this);
  }

  void reload() {
    _settingsManager.load(
      () => setState(() {
        _intervalMils = (_settingsManager.intervalsQuantum / SettingsManager.intervalsSpeedFactor * 1000).toInt();

        // Then refresh UI with loaded settings...
      }),
    );
  }

  void stop(VoidCallback setStateCallback) {
    if (_isRunning()) {
      _stopTimer();
      _stopCountDown();
      _doAskForStopping(setStateCallback);
    } else {
      setStateCallback();
    }
  }

  Widget _buildCountDown(BuildContext context) {
    return Positioned(
      child: Visibility(
        maintainAnimation: true,
        maintainSemantics: true,
        maintainSize: true,
        maintainState: true,
        visible: _isCountDownVisible,
        child: Opacity(
          opacity: 0.75,
          child: CircularCountDownTimer(
            autoStart: false,
            controller: _countDownController,
            duration: _countDownDuration,
            initialDuration: 0,
            isReverse: true,
            isReverseAnimation: false,
            isTimerTextShown: true,
            height: (MediaQuery.of(context).size.height / 2),
            width: (MediaQuery.of(context).size.width / 2),
            backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primary,
            backgroundGradient: null,
            fillColor: Theme.of(context).buttonTheme.colorScheme!.primary,
            fillGradient: null,
            ringColor: Theme.of(context).buttonTheme.colorScheme!.secondaryContainer,
            ringGradient: null,
            strokeWidth: 20.0,
            strokeCap: StrokeCap.round,
            textStyle: TextStyle(
              fontSize: 30.0,
              color: Theme.of(context).colorScheme.background,
              fontWeight: FontWeight.bold,
            ),
            textFormat: CountdownTextFormat.S,
            timeFormatterFunction: (defaultFormatterFunction, duration) =>
                (duration.inSeconds == 0) ? AppLocalizations.of(context)!.viewPlay_CountDown_Start : Function.apply(defaultFormatterFunction, [duration]),
            onComplete: _onCountDownCompleted,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanelRow(Icon icon, String label, String info) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: icon,
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 3,
          child: Text(
            label,
            textAlign: TextAlign.right,
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: Text(
            info,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoPanelRow(
                const Icon(Icons.timer_outlined),
                AppLocalizations.of(context)!.viewPlay_Info_ElapsedTime_Label,
                _formatDuration(_infoElapsedTimeTotal, _unsetValue),
              ),
              _buildInfoPanelRow(
                const Icon(Icons.straighten),
                AppLocalizations.of(context)!.viewPlay_Info_Count_Intervals_Label,
                ((null != _playEngine) ? _playEngine!.intervalsCount.toString() : _unsetValue),
              ),
              _buildInfoPanelRow(
                const Icon(
                  CustomIcons.musicViolinKey,
                  size: 18,
                ),
                AppLocalizations.of(context)!.viewPlay_Info_Count_Keys_Label,
                ((null != _playEngine) ? _playEngine!.keysCount.toString() : _unsetValue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPanels() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          _buildPlayIntervalPanel(),
          Positioned(
            top: 10,
            right: 10,
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: _buildPlayKeyPanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayIntervalPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20, top: 90),
      child: ValueListenableBuilder(
        valueListenable: _intervalTextNotifier,
        builder: (context, value, child) {
          return Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).buttonTheme.colorScheme?.primary,
              fontFamily: FontsCatalog.roundedLedBoard7,
              fontSize: 60,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayKeyPanel() {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.only(top: 20), // Compensate "fontSize"
                child: WidgetBlinkingText(
                  textAlign: TextAlign.center,
                  textNotifier: _keyTextNotifier,
                  style: TextStyle(
                    color: Theme.of(context).buttonTheme.colorScheme?.error,
                    fontFamily: FontsCatalog.roundedLedBoard7,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolButtonsBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Material(
          elevation: 4.0,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                MaterialButton(
                  onPressed: (_isPlayButtonEnabled ? _onPlayButtonPressed : null),
                  child: Column(
                    children: [
                      const Icon(Icons.directions_run),
                      Text(
                        AppLocalizations.of(context)!.viewPlay_Buttons_Play,
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: (_isPauseButtonEnabled ? _onPauseButtonPressed : null),
                  child: Column(
                    children: [
                      const Icon(Icons.pause),
                      Text(
                        AppLocalizations.of(context)!.viewPlay_Buttons_Pause,
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: (_isStopButtonEnabled ? _onStopButtonPressed : null),
                  child: Column(
                    children: [
                      const Icon(Icons.stop),
                      Text(
                        AppLocalizations.of(context)!.viewPlay_Buttons_Stop,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _doAskForStopping(VoidCallback? setStateCallback) {
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

  void doNext() {
    if (null != _playEngine) {
      var answer = _playEngine!.next();
      _intervalTextNotifier.value = answer.interval;

      if (_settingsManager.keysActive) {
        _keyTextNotifier.value = answer.key;
      }
    }
  }

  void _doPause() {
    _stopTimer();

    setState(() {
      _stopCountDown();
      _updateElapsedTimeTotal();

      _isPlayButtonEnabled = true;
      _isPauseButtonEnabled = false;
      _isStopButtonEnabled = true;
    });
  }

  void _doPlay() {
    setState(() {
      _stopCountDown();
      _resetElapsedTimeSegment();

      if (_isStopped()) {
        _infoElapsedTimeTotal = const Duration();
        _intervalTextNotifier.value = _unsetValue;
        _keyTextNotifier.value = _unsetValue;
        _playEngine = PlayEngine(context, _settingsManager);
      }

      _isPlayButtonEnabled = false;
      _isPauseButtonEnabled = true;
      _isStopButtonEnabled = true;

      _startCountDown();
    });

  }

  void _doStop() {
    _stopTimer();

    setState(() {
      _stopCountDown();
      _updateElapsedTimeTotal();

      _isPlayButtonEnabled = true;
      _isPauseButtonEnabled = false;
      _isStopButtonEnabled = false;
    });
  }

  String _formatDuration(Duration? duration, String nullValue) {
    if (duration == null) {
      return nullValue;
    } else {
      String twoDigit(int n) => n.toString().padLeft(2, "0");

      int minutes = duration.inMinutes;
      int seconds = duration.inSeconds % 60;
      int tenths = (duration.inMilliseconds % 1000) ~/ 100;
      return '${twoDigit(minutes)}:${twoDigit(seconds)}.$tenths';
    }
  }

  bool _isPaused() => !_isPauseButtonEnabled && _isStopButtonEnabled;

  bool _isRunning() => !_isPlayButtonEnabled;

  bool _isStopped() => !_isPauseButtonEnabled && !_isStopButtonEnabled;

  void _onCountDownCompleted() {
    if (isApplicationActive) {
      setState(() {
        _stopCountDown();
        _startTimer();
      });
    }
  }

  void _onPauseButtonPressed() {
    _doPause();
  }

  void _onPlayButtonPressed() {
    _doPlay();
  }

  void _onStopButtonPressed() {
    _stopTimer();
    _stopCountDown();
    _doAskForStopping(null);
  }

  void _onTimer(Timer timer) {
    _stopTimer();

    setState(() {
      doNext();
      _updateElapsedTimeTotal();
      _doFeedback();
    });

    _timer = Timer.periodic(_timerInterval!, _onTimer);
  }

  void _refreshUI({ CallbackAction? callback }) {
    setState(() {
      if (null != callback) {
        callback;
      }
    });
  }

  void _resetElapsedTimeSegment() {
    _infoElapsedTimeSegmentStart = DateTime.now();
  }

  void _startCountDown() {
    if (!_isCountDownVisible) {
      _isCountDownVisible = true;
      _countDownController.start();
    }
  }

  void _startTimer() {
    _timerInterval = Duration(
      milliseconds: _intervalMils,
    );

    _timer = Timer.periodic(_timerInterval!, _onTimer);
    _refreshUI();
  }

  void _stopCountDown() {
    if (_isCountDownVisible) {
      _isCountDownVisible = false;
      _countDownController.reset();
    }
  }

  void _stopTimer() {
    if (null != _timer) {
      _timer?.cancel();
      _timer = null;

      _refreshUI();
    }
  }

  void _updateElapsedTimeTotal() {
    _infoElapsedTimeTotal = _infoElapsedTimeTotal! + DateTime.now().difference(_infoElapsedTimeSegmentStart!);
    _resetElapsedTimeSegment();
  }
}
