import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/ui/widget_countdown_timer.dart';

class WidgetPlayCountDown extends StatefulWidget {
  final WidgetPlayCountDownController controller;
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
    Size size = MediaQuery.of(context).size;

    return Visibility(
      maintainAnimation: true,
      maintainSemantics: true,
      maintainSize: true,
      maintainState: true,
      visible: _isVisible,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5, // Prevents interaction with background buttons
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.black,
            ),
          ),
          Opacity(
            opacity: 0.75,
            child: Center(
              child: WidgetCountDownTimer(
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                controller: widget.controller,
                seconds: widget.seconds,
                lineWidth: 20,
                radius: min(
                  (size.height / 3),
                  (size.width / 3),
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

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
  }
}

class WidgetPlayCountDownController extends WidgetCountDownTimerController{
  late WidgetPlayCountDownState _state;

  bool get isVisible => _state.isVisible;

  set isVisible(bool value) {
    _state.isVisible = value;
  }

}
