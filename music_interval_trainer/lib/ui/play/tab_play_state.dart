import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/tab_play.dart';

class TabPlayState extends State<TabPlay> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        color: Theme.of(context).buttonTheme.colorScheme?.surface,
        child: const Padding(
          padding: EdgeInsets.all(25),
          child: Text(
            "SOLb9",
            style: TextStyle(
              fontFamily: "Rounded-Led-Board-7",
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
