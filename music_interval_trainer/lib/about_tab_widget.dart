import 'package:flutter/material.dart';

class AboutTabWidget extends StatelessWidget {
  const AboutTabWidget({super.key});

  // Theme.of(context).textTheme.labelMedium,
  // Theme.of(context).textTheme.titleMedium,

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                buildAboutBox(context),
                const SizedBox(height: 10),
                buildUserGuideBox(context),
              ],
            )),
      ]),
    );
  }

  Container buildCardWidget(
      BuildContext context, String title, Icon bodyIcon, Widget bodyWidget) {
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

  Container buildAboutBox(BuildContext context) {
    return buildCardWidget(
      context,
      "Application Information", //TODO Localize
      const Icon(Icons.info_outline_rounded),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Music Interval Trainer", //TODO Localize
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text(
            "Version 1.0.0", //TODO Localize
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Divider(height: 5),
          Text(
            "Support email: antonio.petricca@gmail.com",
            //TODO Localize
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Container buildUserGuideBox(BuildContext context) {
    return buildCardWidget(
        context,
      "User Guide", //TODO Localize
        const Icon(Icons.help_outline_outlined),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Music Interval Trainer", //TODO Localize
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              "Version 1.0.0", //TODO Localize
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Divider(height: 5),
            Text(
              "Support email: antonio.petricca@gmail.com",
              //TODO Localize
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
    );
  }

}
