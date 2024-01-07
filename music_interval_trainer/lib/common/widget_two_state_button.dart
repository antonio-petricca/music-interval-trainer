import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/widget_two_state_button_state.dart';

typedef WidgetTwoStateButtonCallback = void Function(WidgetTwoStateButton sender);

class WidgetTwoStateButton extends StatefulWidget {
  dynamic? context;

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
