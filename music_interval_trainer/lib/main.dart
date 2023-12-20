import 'package:flutter/material.dart';

import 'main_page_widget.dart';



/*
 https://docs.flutter.dev/cookbook/design/themes
 https://docs.flutter.dev/ui/layout/tutorial
 */

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Music Interval Trainer', //TODO
      home: MainPageWidget(),
    );
  }
}
