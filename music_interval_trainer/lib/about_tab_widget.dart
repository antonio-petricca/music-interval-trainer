import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'card_widget.dart';

class AboutTabWidget extends StatelessWidget {
  AboutTabWidget({super.key});

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
                buildAboutCard(context),
                const SizedBox(height: 10),
                buildUserGuideCard(context),
              ],
            )),
      ]),
    );
  }

  Widget buildAboutCard(BuildContext context) {
    return CardWidget(
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

  Widget buildUserGuideCard(BuildContext context) {
    return CardWidget(
      "User Guide", //TODO Localize
      const Icon(Icons.help_outline_outlined),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "A video is worth a thousand words!", //TODO Localize
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Divider(height: 5),
            YoutubePlayer(
              controller: YoutubePlayerController( //TODO Video as resources?!
                initialVideoId: 'tIQSV4JJTqI', //TODO Put into resource
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                  hideControls: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
