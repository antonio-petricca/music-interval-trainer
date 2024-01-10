import 'package:flutter/material.dart';

import '../../common/ui/fonts_catalog.dart';
import '../../common/ui/widget_blinking_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewPlay extends StatefulWidget {
  const ViewPlay({super.key});

  @override
  ViewPlayState createState() => ViewPlayState();
}

class ViewPlayState extends State<ViewPlay> {
  final _textNotifier = ValueNotifier<String>('C');

  bool _isPauseButtonEnabled = false;
  bool _isPlayButtonEnabled = true;
  bool _isStopButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_buildPlayPanels(), _buildToolButtonsBar(context)],
    );
  }

  Widget _buildIntervalPanel() {
    return Flexible(
      flex: 4,
      fit: FlexFit.tight,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Text(
            "SOL#",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontsCatalog.roundedLedBoard7,
              fontSize: 30,
              height: 3,
              color: Theme.of(context).buttonTheme.colorScheme?.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyPanel() {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: WidgetBlinkingText(
            textAlign: TextAlign.center,
            textNotifier: _textNotifier,
            style: TextStyle(
              fontFamily: FontsCatalog.roundedLedBoard7,
              fontSize: 20,
              color: Theme.of(context).buttonTheme.colorScheme?.error,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPanels() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntervalPanel(),
          _buildKeyPanel(),
        ],
      ),
    );
  }

  Widget _buildToolButtonsBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Material(
          elevation: 4.0,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                MaterialButton(
                  onPressed: (_isPlayButtonEnabled ? _onPlayButtonPressed : null),
                  child: Column(
                    children: [
                      const Icon(Icons.play_arrow),
                      Text(
                        AppLocalizations.of(context)!.viewPlay_Buttons_Play,
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: (_isPauseButtonEnabled ? _onPauseButtonPressed : null),
                  child: Column(
                    children: [
                      const Icon(Icons.pause),
                      Text(
                        AppLocalizations.of(context)!.viewPlay_Buttons_Pause,
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: (_isStopButtonEnabled ? _onStopButtonPressed : null),
                  child: Column(
                    children: [
                      const Icon(Icons.stop),
                      Text(
                        AppLocalizations.of(context)!.viewPlay_Buttons_Stop,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
