import 'package:flutter/material.dart';

class WidgetIconLayoutExt extends StatelessWidget {
  final Icon icon;
  final String title;
  final ListTileTitleAlignment titleAlignment;
  final List<Widget> widgets;

  const WidgetIconLayoutExt({super.key, required this.title, required this.icon, required this.widgets, this.titleAlignment = ListTileTitleAlignment.top});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      titleAlignment: titleAlignment,
      subtitle: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets,
      ),
    );
  }
}
