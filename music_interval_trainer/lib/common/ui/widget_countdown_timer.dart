import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../utils/constants.dart';

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

  @override
  void initState() {
    super.initState();

    _currentValue = widget.seconds;
    widget.controller._state = this;
  }

  bool start() {
    if (_isRunning) {
      return false;
    }

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

    return true;
  }

  bool stop() {
    if (!_isRunning) {
      return false;
    }

    _timer.cancel();

    while (_timer.isActive) {
      sleep(Constants.oneMillisecond);
    }

    _isRunning = false;

    return true;
  }
}

class WidgetCountDownTimerController {
  late WidgetCountDownTimerState _state;

  bool start() => _state.start();

  bool stop() => _state.stop();
}
