import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/settings_catalog.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/tab_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/widget_icon_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabSettingsState extends State<TabSettings> {
  final double _infoColumnWidth = 150;
  final double _intervalMin = 5;
  final double _intervalMax = 50;

  Duration _duration = const Duration(minutes: 2, seconds: 30);
  double _interval = 50;
  late SharedPreferences _preferences;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(AppLocalizations.of(context)!
              .tabSettings_Exercise_Duration_Label),
          _buildDivider(),
          _buildDurationSelector(context),
          _buildLabel(AppLocalizations.of(context)!
              .tabSettings_Exercise_Interval_Label),
          _buildDivider(),
          _buildIntervalSelector(context),
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

  Widget _buildDurationSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: WidgetIconLayout(
        const Icon(Icons.alarm),
        [
          SizedBox(
            width: _infoColumnWidth,
            child: Text(
              _getDuration(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: MaterialButton(
              color: Theme.of(context).buttonTheme.colorScheme?.primary,
              textColor: Theme.of(context).textTheme.labelLarge?.color,
              onPressed: () => _selectDuration(context),
              child: Text(
                AppLocalizations.of(context)!
                    .tabSettings_Exercise_Duration_Button,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalSelector(BuildContext context) {
    return WidgetIconLayout(
      const Icon(Icons.speed),
      [
        SizedBox(
          width: _infoColumnWidth,
          child: Text(
            AppLocalizations.of(context)!.tabSettings_Exercise_Interval_Value(
              _getInterval(),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Slider(
            value: _interval,
            min: _intervalMin,
            max: _intervalMax,
            onChanged: _setInterval,
          ),
        ),
      ],
    );
  }

  String _getDuration() {
    int minutes = _duration.inMinutes;
    int seconds = (_duration.inSeconds % 60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getInterval() {
    Duration duration = Duration(
      milliseconds: (_interval.toInt() * 100),
    );

    int secs = duration.inSeconds;
    int tenths = ((duration.inMilliseconds - (secs * 1000)) ~/ 100);

    return '${secs.toString()}.${tenths.toString()}';
  }

  _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();

    setState(() {
      int? duration = _preferences.getInt(SettingsCatalog.exerciseDuration);

      if (null != duration) {
        _duration = Duration(milliseconds: duration);
      }

      _interval = _preferences.getDouble(SettingsCatalog.exerciseInterval) ?? _interval;
    });
  }

  _saveSettings() {
    _preferences.setInt(
      SettingsCatalog.exerciseDuration,
      _duration.inMilliseconds,
    );

    _preferences.setDouble(
      SettingsCatalog.exerciseInterval,
      _interval,
    );
  }

  Future<void> _selectDuration(BuildContext context) async {
    final Duration? selectedDuration = await showDurationPicker(
      context: context,
      initialTime: _duration,
      baseUnit: BaseUnit.second,
    );

    if (selectedDuration != _duration) {
      setState(() {
        _duration = selectedDuration!;
        _saveSettings();
      });
    }
  }

  Future<void> _setInterval(double value) async {
    setState(() {
      _interval = value;
      _saveSettings();
    });
  }
}
