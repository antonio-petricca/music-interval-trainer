import 'package:flutter/material.dart';

typedef WidgetTwoStateButtonCallback = void Function(WidgetTwoStateButton sender);

class WidgetTwoStateButton extends StatefulWidget {
  dynamic context;

  bool isOn;
  final WidgetTwoStateButtonCallback? onPressed;

  final Color? colorOff;
  final Color? colorOn;
  final Color? colorText;
  final String text;

  WidgetTwoStateButton({super.key, required this.text, required this.colorText, required this.colorOn, required this.colorOff, required this.onPressed, this.isOn = false, this.context});

  @override
  WidgetTwoStateButtonState createState() => WidgetTwoStateButtonState();
}

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