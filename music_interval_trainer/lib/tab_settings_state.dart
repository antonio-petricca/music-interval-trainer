import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/settings_catalog.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/tab_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/widget_icon_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabSettingsState extends State<TabSettings> {
  final double _infoColumnWidth = 200;

  final double _intervalMin = 5;
  final double _intervalMax = 50;

  Duration _selectedDuration = const Duration(minutes: 2, seconds: 30);
  double _selectedInterval = 20; // 2
  // seconds
  late SharedPreferences _preferences;

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
            child: Text(
              _getExecutionDuration(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
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
        ],
      ),
    );
  }

  Widget _buildExecutionIntervalSelector(BuildContext context) {
    return WidgetIconLayout(
      const Icon(Icons.speed),
      [
        SizedBox(
          width: _infoColumnWidth,
          child: Text(
            AppLocalizations.of(context)!.tabSettings_Exercise_Execution_Interval(
              _getExecutionInterval(),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Slider(
            value: _selectedInterval,
            min: _intervalMin,
            max: _intervalMax,
            onChanged: _setExecutionInterval,
          ),
        ),
      ],
    );
  }

  String _getExecutionDuration() {
    int minutes = _selectedDuration.inMinutes;
    int seconds = (_selectedDuration.inSeconds % 60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getExecutionInterval() {
    Duration duration = Duration(
      milliseconds: (_selectedInterval.toInt() * 100),
    );

    int secs = duration.inSeconds;
    int tenths = ((duration.inMilliseconds - (secs * 1000)) ~/ 100);

    return '${secs.toString()}.${tenths.toString()}';
  }

  _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();

    setState(() {
      int? duration = _preferences.getInt(SettingsCatalog.exerciseExecutionDuration);

      if (null != duration) {
        _selectedDuration = Duration(milliseconds: duration);
      }

      _selectedInterval =
          _preferences.getDouble(SettingsCatalog.exerciseExecutionInterval) ??
              _selectedInterval;
    });
  }

  _saveSettings() {
    _preferences.setInt(
      SettingsCatalog.exerciseExecutionDuration,
      _selectedDuration.inMilliseconds,
    );

    _preferences.setDouble(
      SettingsCatalog.exerciseExecutionInterval,
      _selectedInterval,
    );
  }

  Future<void> _selectExecutionDuration(BuildContext context) async {
    final Duration? selectedDuration = await showDurationPicker(
      context: context,
      initialTime: _selectedDuration,
      baseUnit: BaseUnit.second,
    );

    if (selectedDuration != _selectedDuration) {
      setState(() {
        _selectedDuration = selectedDuration!;
        _saveSettings();
      });
    }
  }

  Future<void> _setExecutionInterval(double value) async {
    setState(() {
      _selectedInterval = value;
      _saveSettings();
    });
  }
}
