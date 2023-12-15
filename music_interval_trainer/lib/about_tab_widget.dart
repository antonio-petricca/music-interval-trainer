import 'package:flutter/material.dart';

// https://docs.flutter.dev/ui/layout/tutorial

class AboutTabWidget extends StatelessWidget {
  const AboutTabWidget({super.key});

  Divider createDivider(BuildContext context) {
    return Divider(
        height: 10,
        color: Theme.of(context).dividerColor,
        thickness: 1,
        indent: 15,
        endIndent: 15
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                "Application Information", //TODO Localize
                style: Theme.of(context).textTheme.headlineSmall
              )
          ),
          createDivider(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Version:",
                    style: Theme.of(context).textTheme.labelMedium
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                    "1.0.0", //TODO From resources
                    style: Theme.of(context).textTheme.labelMedium
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                    "Author:",
                    style: Theme.of(context).textTheme.labelMedium
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                    "Antonio Petricca", //TODO From resources
                    style: Theme.of(context).textTheme.labelMedium
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                    "Support eMail:",
                    style: Theme.of(context).textTheme.labelMedium
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                    "antonio.petricca@gmail.com", //TODO From resources
                    style: Theme.of(context).textTheme.labelMedium
                ),
              ),
            ],
          ),
          createDivider(context),
          Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                  "Help", //TODO Localize
                  style: Theme.of(context).textTheme.headlineSmall
              )
          ),
          createDivider(context),
        ],
      )
    );
  }
}
