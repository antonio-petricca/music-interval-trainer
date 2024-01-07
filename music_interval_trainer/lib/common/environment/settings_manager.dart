import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/settings_catalog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  late SharedPreferences _preferences;

  bool _intervalsAccidentals = false;
  bool _intervalsExtended = false;
  double _intervalsSpeed = 20; // 2 seconds (10 tenths of second * 2)
  bool _keySuggestActivation = false;
  bool _keySuggestionKeyProgression = false;
  int _keySuggestInterval = 7;
  List<bool> _keySuggestKeys = [true, false, false, false, false, false, false, false, false, false, false, false];

  bool get executionAccidentals => _intervalsAccidentals;

  set executionAccidentals(bool value) {
    _intervalsAccidentals = value;
    _save();
  }

  load(VoidCallback callback) async {
    _preferences = await SharedPreferences.getInstance();

    _intervalsAccidentals = _preferences.getBool(SettingsCatalog.intervalsAccidentals) ?? _intervalsAccidentals;

    _intervalsExtended = _preferences.getBool(SettingsCatalog.intervalsExtendedIntervals) ?? _intervalsExtended;
    _intervalsSpeed = _preferences.getDouble(SettingsCatalog.intervalsSpeed) ?? _intervalsSpeed;

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
      SettingsCatalog.intervalsAccidentals,
      _intervalsAccidentals,
    );

    _preferences.setBool(
      SettingsCatalog.intervalsExtendedIntervals,
      _intervalsExtended,
    );

    _preferences.setDouble(
      SettingsCatalog.intervalsSpeed,
      _intervalsSpeed,
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

  bool get executionExtendedIntervals => _intervalsExtended;

  set executionExtendedIntervals(bool value) {
    _intervalsExtended = value;
    _save();
  }

  double get executionInterval => _intervalsSpeed;

  set executionInterval(double value) {
    _intervalsSpeed = value;
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
