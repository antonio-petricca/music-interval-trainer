import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_page.dart';
import 'tab_about.dart';
import 'tab_play.dart';
import 'tab_settings.dart';

class HomePageState extends State<HomePage> {

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
