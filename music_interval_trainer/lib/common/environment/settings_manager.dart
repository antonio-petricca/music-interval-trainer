import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/settings_catalog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  late SharedPreferences _preferences;

  bool _intervalsAccidentals = false;
  bool _intervalsExtended = false;
  double _intervalsSpeed = 20; // 2 seconds (10 tenths of second * 2)

  bool _keysActive = false;
  bool _keysRandom = false;
  int _keysInterval = 7;
  List<bool> _keysList = [true, false, false, false, false, false, false, false, false, false, false, false];

  bool _uxFeedbackSound = true;

  bool get intervalsAccidentals => _intervalsAccidentals;

  set intervalsAccidentals(bool value) {
    _intervalsAccidentals = value;
    _save();
  }

  load(VoidCallback callback) async {
    _preferences = await SharedPreferences.getInstance();

    _intervalsAccidentals = _preferences.getBool(SettingsCatalog.intervalsAccidentals) ?? _intervalsAccidentals;

    _intervalsExtended = _preferences.getBool(SettingsCatalog.intervalsExtendedIntervals) ?? _intervalsExtended;
    _intervalsSpeed = _preferences.getDouble(SettingsCatalog.intervalsSpeed) ?? _intervalsSpeed;

    _keysActive = _preferences.getBool(SettingsCatalog.keysActive) ?? _keysActive;
    _keysRandom = _preferences.getBool(SettingsCatalog.keysRandom) ?? _keysRandom;
    _keysInterval = _preferences.getInt(SettingsCatalog.keysInterval) ?? _keysInterval;

    List<String> tmpKeysList = _preferences.getStringList(SettingsCatalog.keysList) ?? [];

    if (tmpKeysList.isNotEmpty) {
      _keysList = tmpKeysList.map((element) => bool.parse(element)).toList();
    }

    _uxFeedbackSound = _preferences.getBool(SettingsCatalog.uxFeedbackSound) ?? _uxFeedbackSound;

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
      SettingsCatalog.keysActive,
      _keysActive,
    );

    _preferences.setBool(
      SettingsCatalog.keysRandom,
      _keysRandom,
    );

    _preferences.setInt(
      SettingsCatalog.keysInterval,
      _keysInterval,
    );

    List<String> tmpKeysList = _keysList.map((element) => element.toString()).toList();

    _preferences.setStringList(
      SettingsCatalog.keysList,
      tmpKeysList,
    );

    _preferences.setBool(
      SettingsCatalog.uxFeedbackSound,
      _uxFeedbackSound,
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

  bool get keysActive => _keysActive;

  set keysActive(bool value) {
    _keysActive = value;
    _save();
  }

  bool get keysRandom => _keysRandom;

  set keysRandom(bool value) {
    _keysRandom = value;
    _save();
  }

  int get keysInterval => _keysInterval;

  set keysInterval(int value) {
    _keysInterval = value;
    _save();
  }

  List<bool> get keysList => _keysList;

  void keysListItem(int index, bool value) {
    List<bool> newKeys = [ ..._keysList ];
    newKeys[index] = value;

    int trueCount = newKeys.where((element) => (true == element)).toList().length;

    if (trueCount > 0) {
      _keysList = newKeys;
      _save();
    }
  }

  bool get uxFeedbackSound => _uxFeedbackSound;

  set uxFeedbackSound(bool value) {
    _uxFeedbackSound = value;
    _save();
  }
}
