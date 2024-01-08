import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/ui/widget_icon_layout.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/ui/widget_icon_layout_ext.dart';

class WidgetCardLayoutExt extends StatelessWidget {
  final double? elevation;
  final Icon icon;
  final String title;
  final ListTileTitleAlignment iconAlignment;
  final List<Widget> widgets;

  const WidgetCardLayoutExt(
      {super.key, required this.title, required this.iconAlignment, required this.icon, required this.widgets, this.elevation = 5});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: elevation,
        child: WidgetIconLayoutExt(
          icon: icon,
          widgets: widgets,
          title: title,
          titleAlignment: iconAlignment,
        ),
      ),
    );
  }
}
