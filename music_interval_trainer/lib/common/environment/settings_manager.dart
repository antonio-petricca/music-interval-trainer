import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/settings_catalog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const int intervalsSpeedFactor = 2; // 1 (second) / 2
  static const int intervalsSpeedQuantumMax = (15 /* seconds */ * intervalsSpeedFactor);
  static const int intervalsSpeedQuantumMin = (1 /* second */ * intervalsSpeedFactor);
  static const int keyChangeIntervalMax = 100;
  static const int keyChangeIntervalMin = 1;

  /* 25 seconds */

  late SharedPreferences _preferences;

  bool _intervalsAccidentals = false;
  bool _intervalsExtended = false;
  int _intervalsSpeedQuantum = (2 /* seconds */ * intervalsSpeedFactor);

  bool _keysActive = false;
  int _keysChangeInterval = 2;
  bool _keysRandom = false;
  List<bool> _keysList = [true, false, false, false, false, false, false, false, false, false, false, false];

  bool _uxFeedbackSound = true;
  bool _uxFeedbackVibration = false;

  bool get intervalsAccidentals => _intervalsAccidentals;

  set intervalsAccidentals(bool value) {
    _intervalsAccidentals = value;
    _save();
  }

  bool get intervalsExtended => _intervalsExtended;

  set intervalsExtended(bool value) {
    _intervalsExtended = value;
    _save();
  }

  int get intervalsQuantum => _intervalsSpeedQuantum;

  set intervalsQuantum(int value) {
    _intervalsSpeedQuantum = value;
    _save();
  }

  bool get keysActive => _keysActive;

  set keysActive(bool value) {
    _keysActive = value;
    _save();
  }

  int get keysChangeInterval => _keysChangeInterval;

  set keysChangeInterval(int value) {
    _keysChangeInterval = value;
    _save();
  }

  bool get keysRandom => _keysRandom;

  set keysRandom(bool value) {
    _keysRandom = value;
    _save();
  }

  List<bool> get keysList => _keysList;

  void keysListItem(int index, bool value) {
    List<bool> newKeys = [..._keysList];
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

  bool get uxFeedbackVibration => _uxFeedbackVibration;

  set uxFeedbackVibration(bool value) {
    _uxFeedbackVibration = value;
    _save();
  }

  load(VoidCallback callback) async {
    _preferences = await SharedPreferences.getInstance();

    _intervalsAccidentals = _preferences.getBool(SettingsCatalog.intervalsAccidentals) ?? _intervalsAccidentals;

    _intervalsExtended = _preferences.getBool(SettingsCatalog.intervalsExtendedIntervals) ?? _intervalsExtended;
    _intervalsSpeedQuantum = _preferences.getInt(SettingsCatalog.intervalsSpeedQuantum) ?? _intervalsSpeedQuantum;

    _keysActive = _preferences.getBool(SettingsCatalog.keysActive) ?? _keysActive;
    _keysChangeInterval = _preferences.getInt(SettingsCatalog.keysChangeInterval) ?? _keysChangeInterval;
    _keysRandom = _preferences.getBool(SettingsCatalog.keysRandom) ?? _keysRandom;

    List<String> tmpKeysList = _preferences.getStringList(SettingsCatalog.keysList) ?? [];

    if (tmpKeysList.isNotEmpty) {
      _keysList = tmpKeysList.map((element) => bool.parse(element)).toList();
    }

    _uxFeedbackSound = _preferences.getBool(SettingsCatalog.uxFeedbackSound) ?? _uxFeedbackSound;
    _uxFeedbackVibration = _preferences.getBool(SettingsCatalog.uxFeedbackVibration) ?? _uxFeedbackVibration;

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

    _preferences.setInt(
      SettingsCatalog.intervalsSpeedQuantum,
      _intervalsSpeedQuantum,
    );

    _preferences.setBool(
      SettingsCatalog.keysActive,
      _keysActive,
    );

    _preferences.setInt(
      SettingsCatalog.keysChangeInterval,
      _keysChangeInterval,
    );

    _preferences.setBool(
      SettingsCatalog.keysRandom,
      _keysRandom,
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

    _preferences.setBool(
      SettingsCatalog.uxFeedbackVibration,
      _uxFeedbackVibration,
    );
  }
}
