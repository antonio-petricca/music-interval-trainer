import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/ui/widget_two_state_button.dart';

class WidgetTwoStateButtonState extends State<WidgetTwoStateButton> {
  void _onPressed() {
    setState(() {
      widget.isOn = !widget.isOn;
      widget.onPressed!(widget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: widget.isOn ? widget.colorOn : widget.colorOff,
      minWidth: double.infinity,
      onPressed: _onPressed,
      padding: const EdgeInsets.all(0),
      textColor: widget.colorText,
      child: Text(widget.text),
    );
  }
}
