import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/ui/fonts_catalog.dart';
import '../../common/ui/widget_blinking_text.dart';
import '../../common/utils.dart';

class ViewPlay extends StatefulWidget {
  const ViewPlay({super.key});

  @override
  ViewPlayState createState() => ViewPlayState();
}

class ViewPlayState extends State<ViewPlay> {
  final _intervalTextNotifier = ValueNotifier<String>('11b'); //TODO
  final _keyTextNotifier = ValueNotifier<String>('MIb'); //TODO

  bool _isPauseButtonEnabled = false;
  bool _isPlayButtonEnabled = true;
  bool _isStopButtonEnabled = false;


  Duration? _infoElapsedTimeChunk;
  Duration? _infoElapsedTimeTotal;
  int       _infoIntervalsCount = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildPlayPanels(),
            _buildInfoPanel(),
          ],
        ),
        _buildToolButtonsBar(context),
      ],
    );
  }

  Widget _buildInfoPanelRow(Icon icon, String label, String info) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: icon,
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 3,
          child: Text(
            label,
            textAlign: TextAlign.right,
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: Text(
            info,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoPanelRow(
                const Icon(Icons.timer_outlined),
                AppLocalizations.of(context)!.viewPlay_Info_ElapsedTime_Label,
            Utils.formatDuration(_infoElapsedTimeTotal, "-")
              ),
              _buildInfoPanelRow(
                const Icon(Icons.straighten),
                AppLocalizations.of(context)!.viewPlay_Info_Count_Label,
                _infoIntervalsCount.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPanels() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: <Widget>[
          _buildPlayIntervalPanel(),
          Positioned(
            top: 15,
            right: 15,
            child: SizedBox(
              width: 70.0,
              height: 70.0,
              child: _buildPlayKeyPanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayIntervalPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20, top: 90),
      child: ValueListenableBuilder(
        valueListenable: _intervalTextNotifier,
        builder: (context, value, child) {
          return Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).buttonTheme.colorScheme?.primary,
              fontFamily: FontsCatalog.roundedLedBoard7,
              fontSize: 60,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayKeyPanel() {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.only(top: 20), // Compensate "fontSize"
              child: WidgetBlinkingText(
                textAlign: TextAlign.center,
                textNotifier: _keyTextNotifier,
                style: TextStyle(
                  color: Theme.of(context).buttonTheme.colorScheme?.error,
                  fontFamily: FontsCatalog.roundedLedBoard7,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
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
                      const Icon(Icons.directions_run),
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
