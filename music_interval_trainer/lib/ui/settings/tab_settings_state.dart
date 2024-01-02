import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/keys_manager.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/settings_catalog.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/settings/tab_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widget_icon_layout.dart';

class TabSettingsState extends State<TabSettings> {
  late SharedPreferences _preferences;

  final double _infoColumnWidth = 190;

  final double _intervalMin = 5;
  final double _intervalMax = 50;

  bool _selectedExecutionAccidentals = false;
  Duration _selectedExecutionDuration = const Duration(minutes: 2, seconds: 30);
  double _selectedExecutionInterval = 20; // 2 seconds
  bool _selectedKeySuggestActivation = false;
  bool _selectedKeySuggestExtendedIntervals = false;
  int _selectedKeySuggestStartingKey = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(
            AppLocalizations.of(context)!.tabSettings_Exercise_Execution_Section,
          ),
          _buildDivider(),
          _buildExecutionDurationSelector(context),
          _buildExecutionIntervalSelector(context),
          _buildExecutionAccidentals(context),
          _buildExecutionExtendedIntervals(context),
          _buildLabel(
            AppLocalizations.of(context)!.tabSettings_Exercise_Key_Section,
          ),
          _buildDivider(),
          _buildKeySuggestActivation(context),
          _buildKeySuggestStartKey(context),
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
              onChanged: _selectExecutionAccidentals,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionDurationSelector(BuildContext context) {
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
                onPressed: () => _selectExecutionDuration(context),
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

  Widget _buildExecutionIntervalSelector(BuildContext context) {
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
              min: _intervalMin,
              max: _intervalMax,
              onChanged: _setExecutionInterval,
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
              value: _selectedKeySuggestExtendedIntervals,
              onChanged: _selectKeySuggestExtendedIntervals,
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
              onChanged: _selectKeySuggestActivation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeySuggestStartKey(BuildContext context) {
    KeysManager keysManager = KeysManager(context);
    List<String> keyItems = keysManager.getList();

    List<DropdownMenuItem<int>> ddItems = [];
    int ddIndex = 0;

    for (var item in keyItems) {
      ddItems.add(DropdownMenuItem(
        value: ddIndex++,
        child: Text(item),
      ));
    }

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
                AppLocalizations.of(context)!.tabSettings_Exercise_KeySuggest_StartKey,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: DropdownButton<int>(
                value: _selectedKeySuggestStartingKey,
                items: ddItems,
                onChanged: _selectKeySuggestStartingKey,
              ),
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

      _selectedExecutionInterval = _preferences.getDouble(SettingsCatalog.exerciseExecutionInterval) ?? _selectedExecutionInterval;
      _selectedKeySuggestActivation = _preferences.getBool(SettingsCatalog.exerciseKeySuggestActivation) ?? false;

      _selectedKeySuggestExtendedIntervals = _preferences.getBool(SettingsCatalog.exerciseKeySuggestExtendedIntervals) ?? false;
      _selectedKeySuggestStartingKey = _preferences.getInt(SettingsCatalog.exerciseKeySuggestStartingKey) ?? 0;
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

    _preferences.setDouble(
      SettingsCatalog.exerciseExecutionInterval,
      _selectedExecutionInterval,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseKeySuggestActivation,
      _selectedKeySuggestActivation,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseKeySuggestExtendedIntervals,
      _selectedKeySuggestExtendedIntervals,
    );

    _preferences.setInt(
      SettingsCatalog.exerciseKeySuggestStartingKey,
      _selectedKeySuggestStartingKey,
    );
  }

  void _selectExecutionAccidentals(bool? value) {
    setState(() {
      _selectedExecutionAccidentals = (value ?? false);
      _saveSettings();
    });
  }

  Future<void> _selectExecutionDuration(BuildContext context) async {
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

  void _selectKeySuggestStartingKey(int? value) {
    setState(() {
      _selectedKeySuggestStartingKey = value!;
      _saveSettings();
    });
  }

  Future<void> _setExecutionInterval(double value) async {
    setState(() {
      _selectedExecutionInterval = value;
      _saveSettings();
    });
  }

  void _selectKeySuggestActivation(bool? value) {
    setState(() {
      _selectedKeySuggestActivation = (value ?? false);
      _saveSettings();
    });
  }

  void _selectKeySuggestExtendedIntervals(bool? value) {
    setState(() {
      _selectedKeySuggestExtendedIntervals = (value ?? false);
      _saveSettings();
    });
  }
}
