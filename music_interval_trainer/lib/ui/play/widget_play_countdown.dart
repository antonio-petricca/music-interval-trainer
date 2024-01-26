import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/ui/widget_countdown_timer.dart';

class WidgetPlayCountDown extends StatefulWidget {
  final WidgetCountDownTimerController controller;
  final int seconds;
  final VoidCallback onComplete;

  const WidgetPlayCountDown({
    super.key,
    required this.controller,
    required this.seconds,
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
            opacity: 0.5, // Prevents interaction with background buttons
            child: Center(
              child: WidgetCountDownTimer(
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                controller: widget.controller,
                seconds: widget.seconds,
                lineWidth: 20,
                radius: min(
                  (MediaQuery.of(context).size.height / 3),
                  (MediaQuery.of(context).size.width / 3),
                ),
                textStyle: TextStyle(
                  fontSize: 30.0,
                  color: Theme.of(context).colorScheme.background,
                  fontWeight: FontWeight.bold,
                ),
                onComplete: widget.onComplete,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
