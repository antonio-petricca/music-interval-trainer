import 'package:duration_picker/duration_picker.dart';
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

  final double _infoColumnWidth = 180;

  final double _executionIntervalMin = 5;
  final double _executionIntervalMax = 50;
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

    _settingsManager.load(
      () => setState(() {
        // Refresh UI
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
              value: _settingsManager.executionAccidentals,
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
              value: _settingsManager.executionInterval,
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
              value: _settingsManager.executionExtendedIntervals,
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
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
              value: _settingsManager.keySuggestionKeyProgression,
              onChanged: _onKeySuggestProgressionPressed,
            ),
          ),
        ],
      ),
    );
  }

  void _onExecutionAccidentalsPressed(bool? value) {
    setState(() {
      _settingsManager.executionAccidentals = (value ?? false);
    });
  }

  String _getExecutionDuration() {
    Duration duration = _settingsManager.executionDuration;
    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds % 60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getExecutionInterval() {
    Duration duration = Duration(
      milliseconds: (_settingsManager.executionInterval.toInt() * 100),
    );

    int secs = duration.inSeconds;
    int tenths = ((duration.inMilliseconds - (secs * 1000)) ~/ 100);

    return '${secs.toString()}.${tenths.toString()}';
  }

  Future<void> _onExecutionDurationPressed(BuildContext context) async {
    Duration duration = _settingsManager.executionDuration;

    final Duration? selectedDuration = await showDurationPicker(
      context: context,
      initialTime: duration,
      baseUnit: BaseUnit.second,
    );

    if (selectedDuration != duration) {
      setState(() {
        _settingsManager.executionDuration = selectedDuration!;
      });
    }
  }

  void _onExecutionExtendedIntervalsPressed(bool? value) {
    setState(() {
      _settingsManager.executionExtendedIntervals = (value ?? false);
    });
  }

  Future<void> _onExecutionIntervalPressed(double value) async {
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
