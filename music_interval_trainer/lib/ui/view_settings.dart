import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/environment/keys_manager.dart';
import '../common/environment/settings_manager.dart';
import '../common/ui/custom_icons.dart';
import '../common/ui/widget_icon_layout_ext.dart';
import '../common/ui/widget_two_state_button.dart';

class ViewSettings extends StatefulWidget {
  const ViewSettings({super.key});

  @override
  ViewSettingsState createState() => ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  late List<String> _keyLabels;
  final SettingsManager _settingsManager = SettingsManager();

  final EdgeInsetsGeometry _editorColumnPadding = const EdgeInsets.fromLTRB(20, 0, 20, 0);
  final double _infoColumnWidth = 150;
  final EdgeInsetsGeometry _infoColumnPadding = const EdgeInsets.fromLTRB(0, 0, 10, 0);

  final double _intervalsSpeedMin = 5;
  final double _intervalsSpeedMax = 50;
  final double _keySuggestIntervalMin = 1;
  final double _keySuggestIntervalMax = 100;

  @override
  Widget build(BuildContext context) {
    _keyLabels = KeysManager(context).getList();

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(
              AppLocalizations.of(context)!.viewSettings_Intervals_Section,
            ),
            _buildDivider(),
            _buildIntervalsSpeed(context),
            _buildIntervalsAccidentals(context),
            _buildIntervalsExtended(context),
            _buildLabel(
              AppLocalizations.of(context)!.viewSettings_Keys_Section,
            ),
            _buildDivider(),
            _buildKeysActive(context),
            _buildKeysList(context),
            _buildKeysRandom(context),
            _buildKeysInterval(context)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _settingsManager.load(
      () => setState(() {
        // Refresh UI with loaded settings.
      }),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 5,
      indent: 5,
      endIndent: 5,
    );
  }

  Widget _buildLabel(String caption) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
      child: Text(
        caption,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Widget _buildIntervalsAccidentals(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(CustomIcons.musicFlat),
      iconAlignment: ListTileTitleAlignment.top,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_Intervals_Accidentals,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Padding(
          padding: _editorColumnPadding,
          child: Switch(
            value: _settingsManager.intervalsAccidentals,
            onChanged: _onIntervalsAccidentalsChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildIntervalsSpeed(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(Icons.timelapse_outlined),
      iconAlignment: ListTileTitleAlignment.center,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_Intervals_Speed(
                _getIntervalsSpeed(),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: _settingsManager.executionInterval,
            min: _intervalsSpeedMin,
            max: _intervalsSpeedMax,
            onChanged: _onIntervalsSpeedChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildIntervalsExtended(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(CustomIcons.musicGraceNote),
      iconAlignment: ListTileTitleAlignment.top,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_Intervals_Extended,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Padding(
          padding: _editorColumnPadding,
          child: Switch(
            value: _settingsManager.executionExtendedIntervals,
            onChanged: _onIntervalsExtendedChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildKeysActive(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(Icons.power_settings_new),
      iconAlignment: ListTileTitleAlignment.center,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_Keys_Activation,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Padding(
          padding: _editorColumnPadding,
          child: Switch(
            value: _settingsManager.keysActive,
            onChanged: _onKeysActivateChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildKeysInterval(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(Icons.trending_up),
      iconAlignment: ListTileTitleAlignment.center,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_Keys_Interval(
                _settingsManager.keysInterval,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: _settingsManager.keysInterval.toDouble(),
            min: _keySuggestIntervalMin,
            max: _keySuggestIntervalMax,
            onChanged: _onKeysIntervalChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildKeysList(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(CustomIcons.musicViolinKey),
      iconAlignment: ListTileTitleAlignment.center,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_Keys_Keys,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(
              12,
              _buildKeysListGridItem,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeysListGridItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: WidgetTwoStateButton(
        context: index,
        isOn: _settingsManager.keysList[index],
        onPressed: _onKeysGridItemChanged,
        colorOff: Theme.of(context).buttonTheme.colorScheme?.secondaryContainer,
        colorOn: Theme.of(context).buttonTheme.colorScheme?.primary,
        colorText: Theme.of(context).colorScheme.background,
        text: _keyLabels[index],
      ),
    );
  }

  Widget _buildKeysRandom(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(Icons.loop),
      iconAlignment: ListTileTitleAlignment.center,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_Keys_Random,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Padding(
          padding: _editorColumnPadding,
          child: Switch(
            value: _settingsManager.keysRandom,
            onChanged: _onKeysRandomChanged,
          ),
        ),
      ],
    );
  }

  String _getIntervalsSpeed() {
    Duration duration = Duration(
      milliseconds: (_settingsManager.executionInterval.toInt() * 100),
    );

    int secs = duration.inSeconds;
    int tenths = ((duration.inMilliseconds - (secs * 1000)) ~/ 100);

    return '${secs.toString()}.${tenths.toString()}';
  }

  void _onIntervalsAccidentalsChanged(bool? value) {
    setState(() {
      _settingsManager.intervalsAccidentals = (value ?? false);
    });
  }

  void _onIntervalsExtendedChanged(bool? value) {
    setState(() {
      _settingsManager.executionExtendedIntervals = (value ?? false);
    });
  }

  Future<void> _onIntervalsSpeedChanged(double value) async {
    setState(() {
      _settingsManager.executionInterval = value;
    });
  }

  void _onKeysActivateChanged(bool? value) {
    setState(() {
      _settingsManager.keysActive = (value ?? false);
    });
  }

  void _onKeysGridItemChanged(WidgetTwoStateButton sender) {
    setState(() {
      _settingsManager.keysListItem(
        sender.context,
        sender.isOn,
      );
    });
  }

  Future<void> _onKeysIntervalChanged(double value) async {
    setState(() {
      _settingsManager.keysInterval = value.toInt();
    });
  }

  void _onKeysRandomChanged(bool? value) {
    setState(() {
      _settingsManager.keysRandom = (value ?? false);
    });
  }
}
