import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/keys_manager.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/settings/tab_settings.dart';

import '../../common/environment/settings_manager.dart';
import '../../common/ui/widget_icon_layout.dart';
import '../../common/ui/widget_two_state_button.dart';

class TabSettingsState extends State<TabSettings> {
  late List<String> _keyLabels;
  final SettingsManager _settingsManager = SettingsManager();

  final EdgeInsetsGeometry _editorColumnPadding = const EdgeInsets.fromLTRB(20, 0, 20, 0);
  final double _infoColumnWidth = 180;
  final EdgeInsetsGeometry _infoColumnPadding = const EdgeInsets.fromLTRB(0, 0, 10, 0);

  final double _intervalsSpeedMin = 5;
  final double _intervalsSpeedMax = 50;
  final double _keySuggestIntervalMin = 1;
  final double _keySuggestIntervalMax = 100;

  @override
  Widget build(BuildContext context) {
    _keyLabels = KeysManager(context).getList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(
            AppLocalizations.of(context)!.tabSettings_Intervals_Section,
          ),
          _buildDivider(),
          _buildIntervalsSpeed(context),
          _buildIntervalsAccidentals(context),
          _buildIntervalsExtended(context),
          _buildLabel(
            AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggestion_Section,
          ),
          _buildDivider(),
          _buildKeySuggestActivation(context),
          _buildKeySuggestKeys(context),
          _buildKeySuggestKeyProgression(context),
          _buildKeySuggestInterval(context),
        ],
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
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.queue_music),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: _infoColumnPadding,
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Intervals_Accidentals,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Padding(
            padding: _editorColumnPadding,
            child: Switch(
              value: _settingsManager.executionAccidentals,
              onChanged: _onIntervalsAccidentalsChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalsSpeed(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.timelapse_outlined),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: _infoColumnPadding,
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Intervals_Speed(
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
      ),
    );
  }

  Widget _buildIntervalsExtended(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.queue_music),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: _infoColumnPadding,
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Intervals_Extended,
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
      ),
    );
  }

  Widget _buildKeySuggestActivation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.power_settings_new),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: _infoColumnPadding,
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggest_Activation,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Padding(
            padding: _editorColumnPadding,
            child: Switch(
              value: _settingsManager.keySuggestActivation,
              onChanged: _onKeySuggestActivationPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeySuggestInterval(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.trending_up),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: _infoColumnPadding,
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggest_Interval(
                  _settingsManager.keySuggestInterval,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: _settingsManager.keySuggestInterval.toDouble(),
              min: _keySuggestIntervalMin,
              max: _keySuggestIntervalMax,
              onChanged: _onKeySuggestIntervalPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeySuggestKeys(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.vpn_key),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: _infoColumnPadding,
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggest_Keys,
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
                _buildKeySuggestKeysGridCell,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeySuggestKeysGridCell(int index) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: WidgetTwoStateButton(
        context: index,
        isOn: _settingsManager.keySuggestKeys[index],
        onPressed: _onKeySuggestKeysGridCellPressed,
        colorOff: Theme.of(context).buttonTheme.colorScheme?.secondaryContainer,
        colorOn: Theme.of(context).buttonTheme.colorScheme?.primary,
        colorText: Theme.of(context).colorScheme.background,
        text: _keyLabels[index],
      ),
    );
  }

  Widget _buildKeySuggestKeyProgression(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.loop),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: _infoColumnPadding,
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggest_Progression,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Padding(
            padding: _editorColumnPadding,
            child: Switch(
              value: _settingsManager.keySuggestionKeyProgression,
              onChanged: _onKeySuggestProgressionPressed,
            ),
          ),
        ],
      ),
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
      _settingsManager.executionAccidentals = (value ?? false);
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

  void _onKeySuggestActivationPressed(bool? value) {
    setState(() {
      _settingsManager.keySuggestActivation = (value ?? false);
    });
  }

  void _onKeySuggestKeysGridCellPressed(WidgetTwoStateButton sender) {
    setState(() {
      _settingsManager.setKeySuggestKeys(
        sender.context,
        sender.isOn,
      );
    });
  }

  Future<void> _onKeySuggestIntervalPressed(double value) async {
    setState(() {
      _settingsManager.keySuggestInterval = value.toInt();
    });
  }

  void _onKeySuggestProgressionPressed(bool? value) {
    setState(() {
      _settingsManager.keySuggestionKeyProgression = (value ?? false);
    });
  }
}
