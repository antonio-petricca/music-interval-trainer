import 'package:flutter/material.dart';

class WidgetIconLayout extends StatelessWidget {
  final Icon icon;
  final Widget widget;

  const WidgetIconLayout(this.icon, this.widget,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: icon,
        ),
        widget
      ],
    );
  }
}
