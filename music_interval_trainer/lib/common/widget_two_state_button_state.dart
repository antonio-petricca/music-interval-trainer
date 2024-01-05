import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/widget_two_state_button.dart';

class WidgetTwoStateButtonState extends State<WidgetTwoStateButton> {
  void _onPressed() {
    setState(() {
      widget.isOn = !widget.isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(0),
      minWidth: double.infinity,
      onPressed: _onPressed,
      color: widget.isOn ? widget.onColor : widget.offColor,
      textColor: widget.textColor,
      child: Text(widget.text),
    );
  }
}
