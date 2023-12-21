import 'package:flutter/material.dart';
import 'package:music_interval_trainer/tab_about_information.dart';
import 'package:music_interval_trainer/tab_about_guide.dart';

class TabAbout extends StatelessWidget {
  const TabAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Container(
            padding: const EdgeInsets.all(5),
            child: const Column(
              children: [
                TabAboutInformation(),
                SizedBox(height: 10),
                TabAboutGuide(),
              ],
            )),
      ]),
    );
  }
}
