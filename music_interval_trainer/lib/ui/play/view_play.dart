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

  bool _isPauseButtonEnabled = false;
  bool _isPlayButtonEnabled = true;
  bool _isStopButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIntervalPanel(),
            _buildKeyPanel(),
          ],
        ),
        _buildToolButtonsBar()
      ],
    );
  }

  Widget _buildIntervalPanel() {
    return Text(
      _note,
      style: TextStyle(
        fontFamily: FontsCatalog.roundedLedBoard7,
        fontSize: _size,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).buttonTheme.colorScheme?.primary,
      ),
    );
  }

  Widget _buildKeyPanel() {
    return WidgetBlinkingText(
      textAlign: TextAlign.center,
      textNotifier: _textNotifier,
      style: TextStyle(
        fontFamily: FontsCatalog.roundedLedBoard7,
        fontSize: _size,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).buttonTheme.colorScheme?.primary,
      ),
    );
  }

  Widget _buildToolButtonsBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Material(
          elevation: 4.0,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              MaterialButton(
                onPressed: (_isPlayButtonEnabled ? _onPlayButtonPressed : null),
                child: const Icon(Icons.play_arrow),
              ),
              MaterialButton(
                onPressed: (_isPauseButtonEnabled ? _onPauseButtonPressed : null),
                child: const Icon(Icons.pause),
              ),
              MaterialButton(
                onPressed: (_isStopButtonEnabled ? _onStopButtonPressed : null),
                child: const Icon(Icons.stop),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressed() {
    _textNotifier.value = DateTime.timestamp().toString();
  }

  void _onPauseButtonPressed() {
    setState(() {
      _isPlayButtonEnabled = true;
      _isPauseButtonEnabled = false;
      _isStopButtonEnabled = true;
    });
  }

  void _onPlayButtonPressed() {
    setState(() {
      _isPlayButtonEnabled = false;
      _isPauseButtonEnabled = true;
      _isStopButtonEnabled = true;
    });
  }

  void _onStopButtonPressed() {
    setState(() {
      _isPlayButtonEnabled = true;
      _isPauseButtonEnabled = false;
      _isStopButtonEnabled = false;
    });
  }
}
