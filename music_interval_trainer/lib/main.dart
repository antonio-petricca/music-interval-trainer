import 'package:flutter/material.dart';

import 'main_page_widget.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Interval Trainer', //TODO
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainPageWidget(), //TODO (title: 'Music Interval Trainer'),
    );
  }
}
