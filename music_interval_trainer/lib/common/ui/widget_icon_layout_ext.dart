import 'package:flutter/material.dart';

class WidgetIconLayoutExt extends StatelessWidget {
  final Icon icon;
  final ListTileTitleAlignment iconAlignment;
  final String? title;
  final List<Widget> children;

  const WidgetIconLayoutExt({
    super.key,
    this.title,
    required this.icon,
    this.iconAlignment = ListTileTitleAlignment.top,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: ((null != title) ? Text(title!) : null),
      titleAlignment: iconAlignment,
      subtitle: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
