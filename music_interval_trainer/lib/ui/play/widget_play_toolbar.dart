import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum WidgetPlayToolbarStatus {
  paused,
  running,
  stopped,
}

class WidgetPlayToolbar extends StatefulWidget {
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const WidgetPlayToolbar({
    super.key,
    required this.onPause,
    required this.onResume,
    required this.onStart,
    required this.onStop,
  });

  @override
  WidgetPlayToolbarState createState() => WidgetPlayToolbarState();
}

class WidgetPlayToolbarState extends State<WidgetPlayToolbar> {
  WidgetPlayToolbarStatus _status = WidgetPlayToolbarStatus.stopped;

  WidgetPlayToolbarStatus get status => _status;

  set status(WidgetPlayToolbarStatus value) {
    if (value != _status) {
      setState(() {
        _status = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: (_statusIsNot(WidgetPlayToolbarStatus.running) ? _onPlayButtonPressed : null),
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
                  onPressed: (_statusIs(WidgetPlayToolbarStatus.running) ? _onPauseButtonPressed : null),
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
                  onPressed: (_statusIsNot(WidgetPlayToolbarStatus.stopped) ? _onStopButtonPressed : null),
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

  bool pause() {
    if (_statusIsNot(WidgetPlayToolbarStatus.running)) {
      return false;
    }

    _onPauseButtonPressed();
    return true;
  }

  bool resume() {
    if (_statusIsNot(WidgetPlayToolbarStatus.paused)) {
      return false;
    }

    _onPlayButtonPressed();
    return true;
  }

  bool start() {
    if (_statusIs(WidgetPlayToolbarStatus.running)) {
      return false;
    }

    _onPlayButtonPressed();
    return true;
  }

  bool stop() {
    if (_statusIs(WidgetPlayToolbarStatus.stopped)) {
      return false;
    }

    _onStopButtonPressed();
    return true;
  }

  void _onPauseButtonPressed() {
    setState(() {
      _status = WidgetPlayToolbarStatus.paused;
      widget.onPause();
    });
  }

  void _onPlayButtonPressed() {
    setState(() {
      bool wasPaused = _statusIs(WidgetPlayToolbarStatus.paused);
      _status = WidgetPlayToolbarStatus.running;

      if (wasPaused) {
        widget.onResume();
      } else {
        widget.onStart();
      }
    });
  }

  void _onStopButtonPressed() {
    setState(() {
      _status = WidgetPlayToolbarStatus.stopped;
      widget.onStop();
    });
  }

  bool _statusIs(WidgetPlayToolbarStatus status) {
    return (_status == status);
  }

  bool _statusIsNot(WidgetPlayToolbarStatus status) {
    return (_status != status);
  }
}
