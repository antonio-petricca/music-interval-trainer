import 'package:flutter/material.dart';

import 'AboutTabWidget.dart';
import 'MainPageWidget.dart';
import 'PlayTabWidget.dart';
import 'SettingsTabWidget.dart';

class MainPageWidgetState extends State<MainPageWidget> {
  int _counter = 0;

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
    /*return Scaffold( //TODO
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //TODO title: Text(widget.title),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );*/

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
          title: const Text('Tabs Demo'),
        ),
        body: const TabBarView(
          children: [
            AboutTabWidget(),
            SettingsTabWidget(),
            PlayTabWidget(),
          ],
        ),
      ),
    );
  }
}