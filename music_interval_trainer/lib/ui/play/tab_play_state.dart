import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/tab_play.dart';

class TabPlayState extends State<TabPlay> {
  final String _note = "SOL#9 REb11";
  final double _size = 20;

  @override
  Widget build(BuildContext context) {
    final Color? color = Theme.of(context).buttonTheme.colorScheme?.primary;

    return Center(
      child: Card(
        elevation: 5,
        color: Theme.of(context).buttonTheme.colorScheme?.surface,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(_note,
                  style: TextStyle(
                    fontFamily: "Rounded-Led-Board-7",
                    fontSize: _size,
                    fontWeight: FontWeight.w400,
                    color: color,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
