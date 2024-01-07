import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/keys_manager.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/settings_catalog.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/settings/tab_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widget_icon_layout.dart';
import '../../common/widget_two_state_button.dart';

class TabSettingsState extends State<TabSettings> {
  late List<String> _keyLabels;
  late SharedPreferences _preferences;

  final double _infoColumnWidth = 180;

  final double _executionIntervalMin = 5;
  final double _executionIntervalMax = 50;
  final double _keySuggestIntervalMin = 0;
  final double _keySuggestIntervalMax = 100;

  bool _selectedExecutionAccidentals = false;
  Duration _selectedExecutionDuration = const Duration(minutes: 2, seconds: 30);
  double _selectedExecutionInterval = 20; // 2 seconds
  bool _selectedKeySuggestActivation = false;
  bool _selectedExecutionExtendedIntervals = false;
  bool _selectedKeySuggestionKeyProgression = false;
  int _selectedKeySuggestInterval = 7;
  List<bool> _selectedKeySuggestKeys = List.filled(12, false);

  @override
  Widget build(BuildContext context) {
    _keyLabels = KeysManager(context).getList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(
            AppLocalizations.of(context)!.tabSettings_Exercise_Execution_Section,
          ),
          _buildDivider(),
          _buildExecutionDuration(context),
          _buildExecutionInterval(context),
          _buildExecutionAccidentals(context),
          _buildExecutionExtendedIntervals(context),
          _buildLabel(
            AppLocalizations.of(context)!.tabSettings_Exercise_Key_Section,
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
    _loadSettings();
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

  Widget _buildExecutionAccidentals(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.queue_music),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_Execution_Accidentals,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Switch(
              value: _selectedExecutionAccidentals,
              onChanged: _onExecutionAccidentalsPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionDuration(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.timer_outlined),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                _getExecutionDuration(),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: MaterialButton(
                color: Theme.of(context).buttonTheme.colorScheme?.primary,
                textColor: Theme.of(context).textTheme.labelLarge?.color,
                onPressed: () => _onExecutionDurationPressed(context),
                child: Text(
                  AppLocalizations.of(context)!.tabSettings_Exercise_Execution_Duration,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionInterval(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.timelapse_outlined),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_Execution_Interval(
                  _getExecutionInterval(),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: _selectedExecutionInterval,
              min: _executionIntervalMin,
              max: _executionIntervalMax,
              onChanged: _onExecutionIntervalPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionExtendedIntervals(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.queue_music),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_Execution_Extended_Intervals,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Switch(
              value: _selectedExecutionExtendedIntervals,
              onChanged: _onExecutionExtendedIntervalsPressed,
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
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggest_Activation,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Switch(
              value: _selectedKeySuggestActivation,
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
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggest_Interval(
                  _selectedKeySuggestInterval.toInt(),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: _selectedKeySuggestInterval.toDouble(),
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
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggest_Keys,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            child: _buildKeySuggestKeysGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildKeySuggestKeysGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(
        12,
        _buildKeySuggestKeysGridCell,
      ),
    );
  }

  Widget _buildKeySuggestKeysGridCell(int index) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: WidgetTwoStateButton(
        context: index,
        isOn: false,
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
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggest_Progression,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Switch(
              value: _selectedKeySuggestionKeyProgression,
              onChanged: _onKeySuggestKeySuggestionPressed,
            ),
          ),
        ],
      ),
    );
  }

  String _getExecutionDuration() {
    int minutes = _selectedExecutionDuration.inMinutes;
    int seconds = (_selectedExecutionDuration.inSeconds % 60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getExecutionInterval() {
    Duration duration = Duration(
      milliseconds: (_selectedExecutionInterval.toInt() * 100),
    );

    int secs = duration.inSeconds;
    int tenths = ((duration.inMilliseconds - (secs * 1000)) ~/ 100);

    return '${secs.toString()}.${tenths.toString()}';
  }

  _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();

    setState(() {
      _selectedExecutionAccidentals = _preferences.getBool(SettingsCatalog.exerciseExecutionAccidentals) ?? false;

      int? duration = _preferences.getInt(SettingsCatalog.exerciseExecutionDuration);

      if (null != duration) {
        _selectedExecutionDuration = Duration(milliseconds: duration);
      }

      _selectedExecutionExtendedIntervals = _preferences.getBool(SettingsCatalog.exerciseExecutionExtendedIntervals) ?? false;
      _selectedExecutionInterval = _preferences.getDouble(SettingsCatalog.exerciseExecutionInterval) ?? _selectedExecutionInterval;

      _selectedKeySuggestActivation = _preferences.getBool(SettingsCatalog.exerciseKeySuggestActivation) ?? false;
      _selectedKeySuggestionKeyProgression = _preferences.getBool(SettingsCatalog.exerciseKeySuggestKeyProgression) ?? false;
      _selectedKeySuggestInterval = _preferences.getInt(SettingsCatalog.exerciseKeySuggestInterval) ?? 0;
    });
  }

  Future<void> _onExecutionDurationPressed(BuildContext context) async {
    final Duration? selectedDuration = await showDurationPicker(
      context: context,
      initialTime: _selectedExecutionDuration,
      baseUnit: BaseUnit.second,
    );

    if (selectedDuration != _selectedExecutionDuration) {
      setState(() {
        _selectedExecutionDuration = selectedDuration!;
        _saveSettings();
      });
    }
  }

  void _onExecutionExtendedIntervalsPressed(bool? value) {
    setState(() {
      _selectedExecutionExtendedIntervals = (value ?? false);
      _saveSettings();
    });
  }

  Future<void> _onExecutionIntervalPressed(double value) async {
    setState(() {
      _selectedExecutionInterval = value;
      _saveSettings();
    });
  }

  void _onKeySuggestActivationPressed(bool? value) {
    setState(() {
      _selectedKeySuggestActivation = (value ?? false);
      _saveSettings();
    });
  }

  void _onKeySuggestKeysGridCellPressed(WidgetTwoStateButton sender) {
    _saveSettings(); //TODO
  }

  Future<void> _onKeySuggestIntervalPressed(double value) async {
    setState(() {
      _selectedKeySuggestInterval = value.toInt();
      _saveSettings();
    });
  }

  void _onKeySuggestKeySuggestionPressed(bool? value) {
    setState(() {
      _selectedKeySuggestionKeyProgression = (value ?? false);
      _saveSettings();
    });
  }

  _saveSettings() {
    _preferences.setBool(
      SettingsCatalog.exerciseExecutionAccidentals,
      _selectedExecutionAccidentals,
    );

    _preferences.setInt(
      SettingsCatalog.exerciseExecutionDuration,
      _selectedExecutionDuration.inMilliseconds,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseExecutionExtendedIntervals,
      _selectedExecutionExtendedIntervals,
    );

    _preferences.setDouble(
      SettingsCatalog.exerciseExecutionInterval,
      _selectedExecutionInterval,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseKeySuggestActivation,
      _selectedKeySuggestActivation,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseKeySuggestKeyProgression,
      _selectedKeySuggestionKeyProgression,
    );

    _preferences.setInt(
      SettingsCatalog.exerciseKeySuggestInterval,
      _selectedKeySuggestInterval,
    );
  }

  void _onExecutionAccidentalsPressed(bool? value) {
    setState(() {
      _selectedExecutionAccidentals = (value ?? false);
      _saveSettings();
    });
  }
}
