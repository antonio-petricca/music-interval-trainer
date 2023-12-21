import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'about_tab_widget.dart';
import 'main_page_widget.dart';
import 'play_tab_widget.dart';
import 'settings_tab_widget.dart';

class MainPageWidgetState extends State<MainPageWidget> {
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
          title: Text(
            Intl.message('', name: 'appTitle'), //TODO
          ), //TODO Localize
        ),
        body: TabBarView(
          children: [
            AboutTabWidget(),
            const SettingsTabWidget(),
            const PlayTabWidget(),
          ],
        ),
      ),
    );
  }
}
