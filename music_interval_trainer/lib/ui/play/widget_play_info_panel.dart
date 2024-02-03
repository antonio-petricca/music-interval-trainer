import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/ui/custom_icons.dart';
import '../../common/utils/constants.dart';

class WidgetPlayInfoPanel extends StatefulWidget {
  final WidgetPlayInfoPanelController controller;
  final int intervalsCount;
  final int keysCount;
  final bool keysActive;

  const WidgetPlayInfoPanel({
    super.key,
    required this.controller,
    required this.intervalsCount,
    required this.keysActive,
    required this.keysCount,
  });

  @override
  WidgetPlayInfoPanelState createState() => WidgetPlayInfoPanelState();
}

class WidgetPlayInfoPanelState extends State<WidgetPlayInfoPanel> {
  Duration _elapsedTime = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow(
                const Icon(Icons.timer_outlined),
                AppLocalizations.of(context)!.viewPlay_Info_ElapsedTime_Label,
                _formatDuration(_elapsedTime, Constants.unsetValue),
              ),
              _buildRow(
                const Icon(Icons.straighten),
                AppLocalizations.of(context)!.viewPlay_Info_Count_Intervals_Label,
                ((Duration.zero != _elapsedTime) ? widget.intervalsCount.toString() : Constants.unsetValue),
              ),
              Visibility(
                maintainState: true,
                visible: widget.keysActive,
                child: _buildRow(
                  const Icon(
                    CustomIcons.musicViolinKey,
                    size: 18,
                  ),
                  AppLocalizations.of(context)!.viewPlay_Info_Count_Keys_Label,
                  ((Duration.zero != _elapsedTime) ? widget.keysCount.toString() : Constants.unsetValue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void increment(Duration value) {
    _elapsedTime = _elapsedTime + value;
  }

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
  }

  void reset() {
    setState(() {
      _elapsedTime = Duration.zero;
    });
  }

  Widget _buildRow(Icon icon, String label, String info) {
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration? duration, String nullValue) {
    if (duration == null) {
      return nullValue;
    } else {
      String twoDigit(int n) => n.toString().padLeft(2, "0");

      int minutes = duration.inMinutes;
      int seconds = duration.inSeconds % 60;
      int tenths = (duration.inMilliseconds % 1000) ~/ 100;
      return '${twoDigit(minutes)}:${twoDigit(seconds)}.$tenths';
    }
  }
}

class WidgetPlayInfoPanelController {
  late WidgetPlayInfoPanelState _state;

  void increment(Duration value) => _state.increment(value);

  void reset() => _state.reset();
}
