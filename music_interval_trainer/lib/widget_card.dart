import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetCard extends StatelessWidget {
  final Icon bodyIcon;
  final Widget bodyWidget;
  final String title;

  const WidgetCard(this.title, this.bodyIcon, this.bodyWidget, {super.key});

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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: bodyIcon,
                  ),
                  bodyWidget
                ],
              ),
            )
          ],
        ));
  }
}
