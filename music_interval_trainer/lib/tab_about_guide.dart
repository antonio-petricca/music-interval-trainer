import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/widget_card_layout.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TabAboutGuide extends StatelessWidget {
  final String _videoId = 'tIQSV4JJTqI';

  const TabAboutGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetCardLayout(
      AppLocalizations.of(context)!.tabAbout_Guide_Title,
      const Icon(Icons.help_outline_outlined),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.tabAbout_Guide_Content,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Divider(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 2,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: _videoId,
                    flags: YoutubePlayerFlags(
                        autoPlay: false,
                        mute: false,
                        hideControls: false,
                        captionLanguage:
                            AppLocalizations.of(context)!.localeName),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
