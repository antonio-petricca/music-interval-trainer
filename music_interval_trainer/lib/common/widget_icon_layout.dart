import 'package:flutter/material.dart';

class WidgetIconLayout extends StatelessWidget {
  final List<Widget> widgets;

  WidgetIconLayout(Icon icon, List<Widget> widgets, {super.key})
      : widgets = [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Center(child: icon),
          ),
          ...widgets,
        ];

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets);
  }
}
