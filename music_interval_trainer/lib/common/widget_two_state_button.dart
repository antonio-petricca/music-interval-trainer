import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/widget_two_state_button_state.dart';

class WidgetTwoStateButton extends StatefulWidget {
  bool isOn;
  String text;

  Color? offColor;
  Color? onColor;
  Color? textColor;

  WidgetTwoStateButton({super.key, required this.text, required this.isOn, required this.textColor, required this.onColor, required this.offColor});

  @override
  WidgetTwoStateButtonState createState() => WidgetTwoStateButtonState();
}
