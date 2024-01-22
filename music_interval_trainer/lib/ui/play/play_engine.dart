import 'dart:math';

import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/settings_manager.dart';

import '../../common/environment/keys_manager.dart';

enum PlayEngineAnswerType { interval, key }

class PlayEngineAnswer {
  final PlayEngineAnswerType _type;
  final String _value;

  PlayEngineAnswer(this._type, this._value);

  PlayEngineAnswerType get type => _type;

  String get value => _value;
}

class PlayEngine {
  final List<String> _keyLabels;
  final SettingsManager _settingsManager;

  final List<String> _accidentals = ['', 'b', '#'];
  final List<String> _standardIntervals = ['1', '2', '3', '4', '5', '6', '7'];
  final List<String> _extendedIntervals = ['1', '2', '3', '4', '5', '6', '7', '9', '11', '13'];

  int _intervalsCount = 0;
  String _prevInterval = "";

  PlayEngine(BuildContext context, SettingsManager settingsManager)
      : _keyLabels = KeysManager(context).getList(),
        _settingsManager = settingsManager;

  PlayEngineAnswer next() {
    return PlayEngineAnswer(
      PlayEngineAnswerType.interval,
      _nextInterval(),
    );
  }

  int get intervalsCount => _intervalsCount;

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
