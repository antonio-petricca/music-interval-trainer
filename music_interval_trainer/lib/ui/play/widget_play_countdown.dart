import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WidgetPlayCountDown extends StatefulWidget {
  final CountDownController controller;
  final int duration;
  final VoidCallback onComplete;

  const WidgetPlayCountDown({
    super.key,
    required this.controller,
    required this.duration,
    required this.onComplete,
  });

  @override
  WidgetPlayCountDownState createState() => WidgetPlayCountDownState();
}

class WidgetPlayCountDownState extends State<WidgetPlayCountDown> {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  set isVisible(bool value) {
    setState(() {
      _isVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainAnimation: true,
      maintainSemantics: true,
      maintainSize: true,
      maintainState: true,
      visible: _isVisible,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.25,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
            ),
          ),
          Opacity(
            opacity: 0.75,
            child: Center(
              child: CircularCountDownTimer(
                autoStart: false,
                controller: widget.controller,
                duration: widget.duration,
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
                onComplete: widget.onComplete,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
