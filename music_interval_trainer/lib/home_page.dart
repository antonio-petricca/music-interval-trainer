import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'ui/about/tab_about.dart';
import 'ui/play/tab_play.dart';
import 'ui/settings/tab_settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.info_outline)),
              Tab(icon: Icon(Icons.settings_outlined)),
              Tab(icon: Icon(Icons.play_arrow_outlined)),
            ],
          ),
          title: Text(AppLocalizations.of(context)!.appTitle),
        ),
        body: const TabBarView(
          children: [
            TabAbout(),
            TabSettings(),
            TabPlay(),
          ],
        ),
      ),
    );
  }
}
