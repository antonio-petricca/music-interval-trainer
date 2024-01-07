import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/settings_catalog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  late SharedPreferences _preferences;

  bool _executionAccidentals = false;
  Duration _executionDuration = const Duration(minutes: 2, seconds: 30);
  bool _executionExtendedIntervals = false;
  double _executionInterval = 20; // 2 seconds (10 tenths of second * 2)
  bool _keySuggestActivation = false;
  bool _keySuggestionKeyProgression = false;
  int _keySuggestInterval = 7;
  List<bool> _keySuggestKeys = [true, false, false, false, false, false, false, false, false, false, false, false];

  bool get executionAccidentals => _executionAccidentals;

  set executionAccidentals(bool value) {
    _executionAccidentals = value;
    _save();
  }

  load(VoidCallback callback) async {
    _preferences = await SharedPreferences.getInstance();

    _executionAccidentals = _preferences.getBool(SettingsCatalog.exerciseExecutionAccidentals) ?? false;

    int? duration = _preferences.getInt(SettingsCatalog.exerciseExecutionDuration);

    if (null != duration) {
      _executionDuration = Duration(milliseconds: duration);
    }

    _executionExtendedIntervals = _preferences.getBool(SettingsCatalog.exerciseExecutionExtendedIntervals) ?? _executionExtendedIntervals;
    _executionInterval = _preferences.getDouble(SettingsCatalog.exerciseExecutionInterval) ?? _executionInterval;

    _keySuggestActivation = _preferences.getBool(SettingsCatalog.exerciseKeySuggestActivation) ?? _keySuggestActivation;
    _keySuggestionKeyProgression = _preferences.getBool(SettingsCatalog.exerciseKeySuggestKeyProgression) ?? _keySuggestionKeyProgression;
    _keySuggestInterval = _preferences.getInt(SettingsCatalog.exerciseKeySuggestInterval) ?? _keySuggestInterval;

    List<String> stateKeySuggestKeys = _preferences.getStringList(SettingsCatalog.exerciseKeySuggestKeys) ?? [];

    if (stateKeySuggestKeys.isNotEmpty) {
      _keySuggestKeys = stateKeySuggestKeys.map((element) => bool.parse(element)).toList();
    }

    callback();
  }

  _save() {
    _preferences.setBool(
      SettingsCatalog.exerciseExecutionAccidentals,
      _executionAccidentals,
    );

    _preferences.setInt(
      SettingsCatalog.exerciseExecutionDuration,
      _executionDuration.inMilliseconds,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseExecutionExtendedIntervals,
      _executionExtendedIntervals,
    );

    _preferences.setDouble(
      SettingsCatalog.exerciseExecutionInterval,
      _executionInterval,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseKeySuggestActivation,
      _keySuggestActivation,
    );

    _preferences.setBool(
      SettingsCatalog.exerciseKeySuggestKeyProgression,
      _keySuggestionKeyProgression,
    );

    _preferences.setInt(
      SettingsCatalog.exerciseKeySuggestInterval,
      _keySuggestInterval,
    );

    List<String> stateKeySuggestKeys = _keySuggestKeys.map((element) => element.toString()).toList();

    _preferences.setStringList(
      SettingsCatalog.exerciseKeySuggestKeys,
      stateKeySuggestKeys,
    );
  }

  Duration get executionDuration => _executionDuration;

  set executionDuration(Duration value) {
    _executionDuration = value;
    _save();
  }

  bool get executionExtendedIntervals => _executionExtendedIntervals;

  set executionExtendedIntervals(bool value) {
    _executionExtendedIntervals = value;
    _save();
  }

  double get executionInterval => _executionInterval;

  set executionInterval(double value) {
    _executionInterval = value;
    _save();
  }

  bool get keySuggestActivation => _keySuggestActivation;

  set keySuggestActivation(bool value) {
    _keySuggestActivation = value;
    _save();
  }

  bool get keySuggestionKeyProgression => _keySuggestionKeyProgression;

  set keySuggestionKeyProgression(bool value) {
    _keySuggestionKeyProgression = value;
    _save();
  }

  int get keySuggestInterval => _keySuggestInterval;

  set keySuggestInterval(int value) {
    _keySuggestInterval = value;
    _save();
  }

  List<bool> get keySuggestKeys => _keySuggestKeys;

  void setKeySuggestKeys(int index, bool value) {
    List<bool> newKeys = [ ..._keySuggestKeys ];
    newKeys[index] = value;

    int trueCount = newKeys.where((element) => (true == element)).toList().length;

    if (trueCount > 0) {
      _keySuggestKeys = newKeys;
      _save();
    }
  }

}
