import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_page.dart';
import 'tab_about.dart';
import 'tab_play.dart';
import 'tab_settings.dart';

class HomePageState extends State<HomePage> {
  final int _counter = 0;

  /*void _incrementCounter() { //TODO

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }*/

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
        body: TabBarView(
          children: [
            TabAbout(),
            const TabSettings(),
            const TabPlay(),
          ],
        ),
      ),
    );
  }
}
