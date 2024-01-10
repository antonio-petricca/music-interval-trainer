import 'package:flutter/material.dart';

import '../../common/ui/fonts_catalog.dart';
import '../../common/ui/widget_blinking_text.dart';

class ViewPlay extends StatefulWidget {
  const ViewPlay({super.key});

  @override
  ViewPlayState createState() => ViewPlayState();
}

class ViewPlayState extends State<ViewPlay> {
  final String _note = "SOL#9 REb11";
  final double _size = 20;
  final _textNotifier = ValueNotifier<String>('Il tuo testo iniziale qui');

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
              Text(
                _note,
                style: TextStyle(
                  fontFamily: FontsCatalog.roundedLedBoard7,
                  fontSize: _size,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
              WidgetBlinkingText(
                textAlign: TextAlign.center,
                textNotifier: _textNotifier,
                style: TextStyle(
                  fontFamily: FontsCatalog.roundedLedBoard7,
                  fontSize: _size,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
              FloatingActionButton.small(
                child: const Icon(Icons.add),
                onPressed: () {
                  _textNotifier.value = DateTime.timestamp().toString();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
