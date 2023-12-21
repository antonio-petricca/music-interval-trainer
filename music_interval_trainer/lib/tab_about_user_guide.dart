import 'package:flutter/material.dart';
import 'package:music_interval_trainer/widget_card.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TabAboutUserGuide extends StatelessWidget {
  const TabAboutUserGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetCard(
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
              controller: YoutubePlayerController(
                //TODO Video as resources?!
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
