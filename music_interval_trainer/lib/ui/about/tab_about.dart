import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/about/tab_about_guide.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/about/tab_about_information.dart';

class TabAbout extends StatelessWidget {
  const TabAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
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
      ),
    );
  }
}
