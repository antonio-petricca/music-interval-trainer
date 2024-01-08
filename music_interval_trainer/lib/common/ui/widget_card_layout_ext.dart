import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/ui/widget_icon_layout_ext.dart';

class WidgetCardLayoutExt extends StatelessWidget {
  final double? elevation;
  final Icon icon;
  final String title;
  final ListTileTitleAlignment iconAlignment;
  final List<Widget> widgets;

  const WidgetCardLayoutExt({
    super.key,
    required this.title,
    required this.iconAlignment,
    required this.icon,
    required this.widgets,
    this.elevation = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: WidgetIconLayoutExt(
        icon: icon,
        title: title,
        iconAlignment: iconAlignment,
        children: widgets,
      ),
    );
  }
}
