import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';

class WidgetCountDownTimer extends StatefulWidget {
  final Color color;
  final WidgetCountDownTimerController controller;
  final double radius;
  final int seconds;
  final double lineWidth;
  final Function onComplete;
  final TextStyle textStyle;

  const WidgetCountDownTimer({
    super.key,
    required this.color,
    required this.controller,
    required this.lineWidth,
    required this.radius,
    required this.onComplete,
    required this.seconds,
    required this.textStyle,
  });

  @override
  WidgetCountDownTimerState createState() => WidgetCountDownTimerState();
}

class WidgetCountDownTimerState extends State<WidgetCountDownTimer> {
  late int _currentValue;
  bool _isRunning = false;
  late Timer _timer;

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _currentValue = widget.seconds;
    widget.controller._state = this;
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      backgroundColor: Colors.grey,
      center: Text(
        _currentValue.toString(),
        style: widget.textStyle,
      ),
      lineWidth: widget.lineWidth,
      percent: (_currentValue / widget.seconds),
      progressColor: widget.color,
      radius: widget.radius,
    );
  }

  void start() {
    if (!_isRunning) {
      _currentValue = widget.seconds;

      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          setState(() {
            if (_currentValue > 0) {
              _currentValue--;
            } else {
              stop();
              widget.onComplete();
            }
          });
        },
      );

      _isRunning = true;
    }
  }

  void stop() {
    if (!_isRunning) {
      _timer.cancel();
      _isRunning = false;
    }
  }
}

class WidgetCountDownTimerController {
  late WidgetCountDownTimerState _state;

  void start() {
    _state.start();
  }

  void stop() {
    _state.stop();
  }
}
