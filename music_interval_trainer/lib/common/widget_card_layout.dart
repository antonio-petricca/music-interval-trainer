import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/widget_icon_layout.dart';

class WidgetCardLayout extends StatelessWidget {
  final Icon bodyIcon;
  final List<Widget> bodyWidgets;
  final String title;

  const WidgetCardLayout(this.title, this.bodyIcon, this.bodyWidgets,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                color: Theme.of(context).primaryColorLight,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: WidgetIconLayout(bodyIcon, bodyWidgets),
            )
          ],
        ));
  }
}
