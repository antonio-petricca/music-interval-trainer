import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/about/widget_about_guide.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/about/widget_about_information.dart';

class ViewAbout extends StatelessWidget {
  const ViewAbout({super.key});

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
                  WidgetAboutInformation(),
                  SizedBox(height: 10),
                  ViewAboutGuide(),
                ],
              )),
        ]),
      ),
    );
  }
}
