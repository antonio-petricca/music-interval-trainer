import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../common/ui/widget_card_layout_ext.dart';

class TabAboutGuide extends StatelessWidget {
  final String _videoId = 'tIQSV4JJTqI';

  const TabAboutGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetCardLayoutExt(
      icon: const Icon(Icons.help_outline_outlined),
      iconAlignment: ListTileTitleAlignment.top,
      title: AppLocalizations.of(context)!.tabAbout_Guide_Title,
      widgets: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.tabAbout_Guide_Content,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
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
                        captionLanguage: AppLocalizations.of(context)!.localeName,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
