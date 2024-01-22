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

  final EdgeInsetsGeometry _editorColumnPadding = const EdgeInsets.only(left: 20, right: 20);
  final double _infoColumnWidth = 150;
  final EdgeInsetsGeometry _infoColumnPadding = const EdgeInsets.only(right: 10);
  final EdgeInsetsGeometry _otherListTilePadding = const EdgeInsets.only(left: 10, right: 10);
  final EdgeInsetsGeometry _sliderListTilePadding = const EdgeInsets.only(left: 10);

  final int _intervalsSpeedQuantumDivisions = (SettingsManager.intervalsSpeedQuantumMax - SettingsManager.intervalsSpeedQuantumMin).toInt();

  @override
  void initState() {
    super.initState();

    _settingsManager.load(
      () => setState(() {
        // Refresh UI with loaded settings.
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _keyLabels = KeysManager(context).getList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(
            AppLocalizations.of(context)!.viewSettings_Intervals_Section_Caption,
            AppLocalizations.of(context)!.viewSettings_Intervals_Section_Tooltip,
          ),
          _buildDivider(),
          _buildIntervalsSpeedQuantum(context),
          _buildIntervalsAccidentals(context),
          _buildIntervalsExtended(context),
          _buildLabel(
            AppLocalizations.of(context)!.viewSettings_Keys_Section_Caption,
            AppLocalizations.of(context)!.viewSettings_Keys_Section_Tooltip,
          ),
          _buildDivider(),
          _buildKeysActive(context),
          _buildKeysList(context),
          _buildKeysRandom(context),
          _buildKeysInterval(context),
          _buildLabel(
            AppLocalizations.of(context)!.viewSettings_UX_Section_Caption,
            AppLocalizations.of(context)!.viewSettings_UX_Section_Tooltip,
          ),
          _buildDivider(),
          _buildUXFeedbackSound(context),
          _buildUXFeedbackVibration(context),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 5,
      indent: 5,
      endIndent: 5,
    );
  }

  Widget _buildLabel(String caption, String tooltip) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
      child: Tooltip(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        message: tooltip,
        child: Text(
          caption,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }

  Widget _buildIntervalsAccidentals(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(CustomIcons.musicFlat),
      iconAlignment: ListTileTitleAlignment.top,
      contentPadding: _otherListTilePadding,
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

  Widget _buildIntervalsExtended(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(CustomIcons.musicGraceNote),
      iconAlignment: ListTileTitleAlignment.top,
      contentPadding: _otherListTilePadding,
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

  Widget _buildIntervalsSpeedQuantum(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(Icons.timelapse_outlined),
      iconAlignment: ListTileTitleAlignment.center,
      contentPadding: _sliderListTilePadding,
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
            value: _settingsManager.executionIntervalQuantum.toDouble(),
            min: SettingsManager.intervalsSpeedQuantumMin.toDouble(),
            max: SettingsManager.intervalsSpeedQuantumMax.toDouble(),
            divisions: _intervalsSpeedQuantumDivisions,
            onChanged: _onIntervalsSpeedQuantumChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildKeysActive(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(Icons.power_settings_new),
      iconAlignment: ListTileTitleAlignment.center,
      contentPadding: _otherListTilePadding,
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
      contentPadding: _otherListTilePadding,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_Keys_ChangeInterval(
                _settingsManager.keysChangeInterval,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: _settingsManager.keysChangeInterval.toDouble(),
            min: SettingsManager.keyChangeIntervalMin.toDouble(),
            max: SettingsManager.keyChangeIntervalMax.toDouble(),
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
      contentPadding: _otherListTilePadding,
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
      contentPadding: _otherListTilePadding,
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

  Widget _buildUXFeedbackSound(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(Icons.volume_up_outlined),
      iconAlignment: ListTileTitleAlignment.center,
      contentPadding: _otherListTilePadding,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_UX_Feedback_Sound,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Padding(
          padding: _editorColumnPadding,
          child: Switch(
            value: _settingsManager.uxFeedbackSound,
            onChanged: _onUXFeedbackSoundChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildUXFeedbackVibration(BuildContext context) {
    return WidgetIconLayoutExt(
      icon: const Icon(Icons.vibration),
      iconAlignment: ListTileTitleAlignment.center,
      contentPadding: _otherListTilePadding,
      children: [
        SizedBox(
          width: _infoColumnWidth,
          child: Padding(
            padding: _infoColumnPadding,
            child: Text(
              AppLocalizations.of(context)!.viewSettings_UX_Feedback_Vibration,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Padding(
          padding: _editorColumnPadding,
          child: Switch(
            value: _settingsManager.uxFeedbackVibration,
            onChanged: _onUXFeedbackVibrationChanged,
          ),
        ),
      ],
    );
  }

  String _getIntervalsSpeed() {
    Duration duration = Duration(
      milliseconds: (_settingsManager.executionIntervalQuantum / SettingsManager.intervalsSpeedFactor * 1000).toInt(),
    );

    int secs = duration.inSeconds;
    int mils = (duration.inMilliseconds - (secs * 1000));
    int milsFraction = mils ~/ 100;

    return '${secs.toString()}.${milsFraction.toString()}';
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

  Future<void> _onIntervalsSpeedQuantumChanged(double value) async {
    setState(() {
      _settingsManager.executionIntervalQuantum = value.toInt();
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
      _settingsManager.keysChangeInterval = value.toInt();
    });
  }

  void _onKeysRandomChanged(bool? value) {
    setState(() {
      _settingsManager.keysRandom = (value ?? false);
    });
  }

  void _onUXFeedbackSoundChanged(bool? value) {
    setState(() {
      _settingsManager.uxFeedbackSound = (value ?? false);
    });
  }

  void _onUXFeedbackVibrationChanged(bool? value) {
    setState(() {
      _settingsManager.uxFeedbackVibration = (value ?? false);
    });
  }
}
