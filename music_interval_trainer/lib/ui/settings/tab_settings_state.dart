import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/keys_manager.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/settings_catalog.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/settings/tab_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/ui/widget_icon_layout.dart';
import '../../common/ui/widget_two_state_button.dart';

class TabSettingsState extends State<TabSettings> {
  late List<String> _keyLabels;
  late SharedPreferences _preferences;

  final double _infoColumnWidth = 180;

  final double _executionIntervalMin = 5;
  final double _executionIntervalMax = 50;
  final double _keySuggestIntervalMin = 0;
  final double _keySuggestIntervalMax = 100;

  bool _stateExecutionAccidentals = false;
  Duration _stateExecutionDuration = const Duration(minutes: 2, seconds: 30);
  double _stateExecutionInterval = 20; // 2 seconds
  bool _stateKeySuggestActivation = false;
  bool _stateExecutionExtendedIntervals = false;
  bool _stateKeySuggestionKeyProgression = false;
  int _stateKeySuggestInterval = 7;
  List<bool> _stateKeySuggestKeys = [true, false, false, false, false, false, false, false, false, false, false, false];

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
    _settingsLoad();
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
              value: _stateExecutionAccidentals,
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
              value: _stateExecutionInterval,
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
              value: _stateExecutionExtendedIntervals,
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
              value: _stateKeySuggestActivation,
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
                  _stateKeySuggestInterval.toInt(),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: _stateKeySuggestInterval.toDouble(),
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
        isOn: _stateKeySuggestKeys[index],
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
              value: _stateKeySuggestionKeyProgression,
              onChanged: _onKeySuggestKeySuggestionPressed,
            ),
          ),
        ],
      ),
    );
  }

  String _getExecutionDuration() {
    int minutes = _stateExecutionDuration.inMinutes;
    int seconds = (_stateExecutionDuration.inSeconds % 60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getExecutionInterval() {
    Duration duration = Duration(
      milliseconds: (_stateExecutionInterval.toInt() * 100),
    );

    int secs = duration.inSeconds;
    int tenths = ((duration.inMilliseconds - (secs * 1000)) ~/ 100);

    return '${secs.toString()}.${tenths.toString()}';
  }

  Future<void> _onExecutionDurationPressed(BuildContext context) async {
    final Duration? selectedDuration = await showDurationPicker(
      context: context,
      initialTime: _stateExecutionDuration,
      baseUnit: BaseUnit.second,
    );

    if (selectedDuration != _stateExecutionDuration) {
      setState(() {
        _stateExecutionDuration = selectedDuration!;
        _settingsSave();
      });
    }
  }

  void _onExecutionExtendedIntervalsPressed(bool? value) {
    setState(() {
      _stateExecutionExtendedIntervals = (value ?? false);
      _settingsSave();
    });
  }

  Future<void> _onExecutionIntervalPressed(double value) async {
    setState(() {
      _stateExecutionInterval = value;
      _settingsSave();
    });
  }

  void _onKeySuggestActivationPressed(bool? value) {
    setState(() {
      _stateKeySuggestActivation = (value ?? false);
      _settingsSave();
    });
  }

  void _onKeySuggestKeysGridCellPressed(WidgetTwoStateButton sender) {
    int index = sender.context;

    setState(() {
      _stateKeySuggestKeys[index] = sender.isOn;

      int setCount = _stateKeySuggestKeys.where((element) => (true == element)).toList().length;

      if (0 == setCount) {
        _stateKeySuggestKeys[index] = true;
      }

      _settingsSave();
    });
  }

  Future<void> _onKeySuggestIntervalPressed(double value) async {
    setState(() {
      _stateKeySuggestInterval = value.toInt();
      _settingsSave();
    });
  }

  void _onKeySuggestKeySuggestionPressed(bool? value) {
    setState(() {
      _stateKeySuggestionKeyProgression = (value ?? false);
      _settingsSave();
    });
  }

  void _onExecutionAccidentalsPressed(bool? value) {
    setState(() {
      _stateExecutionAccidentals = (value ?? false);
      _settingsSave();
    });
  }

  _settingsLoad() async {
    _preferences = await SharedPreferences.getInstance();

    setState(() {
      _stateExecutionAccidentals = _preferences.getBool(SettingsCatalog.exerciseExecutionAccidentals) ?? false;

      int? duration = _preferences.getInt(SettingsCatalog.exerciseExecutionDuration);

      if (null != duration) {
        _stateExecutionDuration = Duration(milliseconds: duration);
      }

      _stateExecutionExtendedIntervals = _preferences.getBool(SettingsCatalog.exerciseExecutionExtendedIntervals) ?? false;
      _stateExecutionInterval = _preferences.getDouble(SettingsCatalog.exerciseExecutionInterval) ?? _stateExecutionInterval;

      _stateKeySuggestActivation = _preferences.getBool(SettingsCatalog.exerciseKeySuggestActivation) ?? false;
      _stateKeySuggestionKeyProgression = _preferences.getBool(SettingsCatalog.exerciseKeySuggestKeyProgression) ?? false;
      _stateKeySuggestInterval = _preferences.getInt(SettingsCatalog.exerciseKeySuggestInterval) ?? 0;

      List<String> stateKeySuggestKeys = _preferences.getStringList(SettingsCatalog.exerciseKeySuggestKeys) ?? [];
      _stateKeySuggestKeys = stateKeySuggestKeys.map((element) => bool.parse(element)).toList();
    });
  }

  _settingsSave() {
    _preferences.setBool(
      SettingsCatalog.exerciseExecutionAccidentals,
      _stateExecutionAccidentals,
    );

    _preferences.setInt(
      SettingsCatalog.exerciseExecutionDuration,
      _stateExecutionDuration.inMilliseconds,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseExecutionExtendedIntervals,
      _stateExecutionExtendedIntervals,
    );

    _preferences.setDouble(
      SettingsCatalog.exerciseExecutionInterval,
      _stateExecutionInterval,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseKeySuggestActivation,
      _stateKeySuggestActivation,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseKeySuggestKeyProgression,
      _stateKeySuggestionKeyProgression,
    );

    _preferences.setInt(
      SettingsCatalog.exerciseKeySuggestInterval,
      _stateKeySuggestInterval,
    );

    List<String> stateKeySuggestKeys = _stateKeySuggestKeys.map((element) => element.toString()).toList();

    _preferences.setStringList(
      SettingsCatalog.exerciseKeySuggestKeys,
      stateKeySuggestKeys,
    );
  }
}
