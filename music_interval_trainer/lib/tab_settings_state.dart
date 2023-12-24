import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/settings_catalog.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/tab_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/widget_icon_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabSettingsState extends State<TabSettings> {
  final double _infoColumnWidth = 190;

  final double _intervalMin = 5;
  final double _intervalMax = 50;

  bool _selectedExecutionAccidentals = false;
  Duration _selectedExecutionDuration = const Duration(minutes: 2, seconds: 30);
  double _selectedExecutionInterval = 20; // 2 seconds
  bool _selectedKeySuggestActivation = false;
  bool _selectedKeySuggestExtendedIntervals = false;

  // seconds
  late SharedPreferences _preferences;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(
            AppLocalizations.of(context)!
                .tabSettings_Exercise_Execution_Section,
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

  Widget _buildExecutionDurationSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.alarm),
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
                  AppLocalizations.of(context)!
                      .tabSettings_Exercise_Execution_Duration,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionIntervalSelector(BuildContext context) {
    return WidgetIconLayout(
      const Icon(Icons.schedule),
      [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Text(
              AppLocalizations.of(context)!
                  .tabSettings_Exercise_Execution_Interval(
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
    );
  }

  Widget _buildExecutionAccidentals(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.translate),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!
                    .tabSettings_Exercise_Execution_Accidentals,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Checkbox(
            value: _selectedExecutionAccidentals,
            onChanged: _selectExecutionAccidentals,
          ),
        ],
      ),
    );
  }

  Widget _buildKeySuggestActivation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.toggle_on),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!
                    .tabSettings_Exercise_KeySuggest_Activation,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Checkbox(
            value: _selectedKeySuggestActivation,
            onChanged: _selectKeySuggestActivation,
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionExtendedIntervals(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.extension),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                AppLocalizations.of(context)!
                    .tabSettings_Exercise_Execution_Extended_Intervals,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Checkbox(
            value: _selectedKeySuggestExtendedIntervals,
            onChanged: _selectKeySuggestExtendedIntervals,
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
      _selectedExecutionAccidentals =
          _preferences.getBool(SettingsCatalog.exerciseExecutionAccidentals) ??
              false;

      int? duration =
          _preferences.getInt(SettingsCatalog.exerciseExecutionDuration);

      if (null != duration) {
        _selectedExecutionDuration = Duration(milliseconds: duration);
      }

      _selectedExecutionInterval =
          _preferences.getDouble(SettingsCatalog.exerciseExecutionInterval) ??
              _selectedExecutionInterval;

      _selectedKeySuggestActivation =
          _preferences.getBool(SettingsCatalog.exerciseKeySuggestActivation) ??
              false;

      _selectedKeySuggestExtendedIntervals = _preferences
              .getBool(SettingsCatalog.exerciseKeySuggestExtendedIntervals) ??
          false;
    });
  }

  _saveSettings() {
    _preferences.setBool(SettingsCatalog.exerciseExecutionAccidentals,
        _selectedExecutionAccidentals);

    _preferences.setInt(
      SettingsCatalog.exerciseExecutionDuration,
      _selectedExecutionDuration.inMilliseconds,
    );

    _preferences.setDouble(
      SettingsCatalog.exerciseExecutionInterval,
      _selectedExecutionInterval,
    );

    _preferences.setBool(SettingsCatalog.exerciseKeySuggestActivation,
        _selectedKeySuggestActivation);

    _preferences.setBool(SettingsCatalog.exerciseKeySuggestExtendedIntervals,
        _selectedKeySuggestExtendedIntervals);
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
