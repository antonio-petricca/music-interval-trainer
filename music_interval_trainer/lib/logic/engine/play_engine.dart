import 'dart:math';

import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/settings_manager.dart';

import 'keys_manager.dart';

class PlayEngineAnswer {
  final String _interval;
  final String _key;

  PlayEngineAnswer(this._interval, this._key);

  String get interval => _interval;

  String get key => _key;
}

class PlayEngine {
  List<String> _keyList = [];
  final SettingsManager _settingsManager;

  final List<String> _accidentals = ['', 'b', '#'];
  final List<String> _standardIntervals = ['1', '2', '3', '4', '5', '6', '7'];
  final List<String> _extendedIntervals = ['1', '2', '3', '4', '5', '6', '7', '9', '11', '13'];

  int _intervalsCount = 0;
  int _keysCount = 0;
  int _keyIndex = 0;
  String _prevInterval = "";
  String _prevKey = "";

  PlayEngine(BuildContext context, SettingsManager settingsManager) : _settingsManager = settingsManager {
    List<String> keyLabels = KeysManager(context).getList();
    List<bool> keySettings = _settingsManager.keysList;

    _keyList = [
      for (int index = 0; index < keySettings.length; index++)
        if (keySettings[index]) keyLabels[index]
    ];
  }

  PlayEngineAnswer next() => PlayEngineAnswer(
        _nextInterval(),
        (_needNewKey() ? _nextKey() : _prevKey),
      );

  int get intervalsCount => _intervalsCount;

  int get keysCount => _keysCount;

  bool _needNewKey() =>
      _settingsManager.keysActive &&
      (_prevKey.isEmpty || (_prevKey.isNotEmpty && (_keyList.length > 1) && (0 == ((_intervalsCount - 1) % _settingsManager.keysChangeInterval))));

  String _nextKey() {
    int index;
    String value;

    var random = Random();

    do {
      if (_settingsManager.keysRandom) {
        index = random.nextInt(_keyList.length - 1);
        value = _keyList[index];
      } else {
        value = _keyList[_keyIndex];

        _keyIndex++;

        if (_keyIndex >= _keyList.length) {
          _keyIndex = 0;
        }
      }
    } while (value == _prevKey);

    _prevKey = value;
    _keysCount++;

    return value;
  }

  String _nextInterval() {
    var intervals = _settingsManager.intervalsExtended ? _extendedIntervals : _standardIntervals;
    var random = Random();

    int index;
    String value;

    do {
      index = random.nextInt(intervals.length - 1);
      value = intervals[index];

      if ((index > 0) /* No unison */ && _settingsManager.intervalsAccidentals) {
        index = random.nextInt(2);
        value += _accidentals[index];
      }
    } while (value == _prevInterval); // Avoid repetitions

    _prevInterval = value;
    _intervalsCount++;

    return value;
  }
}
