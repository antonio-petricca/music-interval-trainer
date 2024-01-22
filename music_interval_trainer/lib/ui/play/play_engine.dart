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
  final SettingsManager _settingsManager;
  final List<String> _keyLabels;

  PlayEngine(BuildContext context, SettingsManager settingsManager)
      : _keyLabels = KeysManager(context).getList(),
        _settingsManager = settingsManager;

  PlayEngineAnswer next() {
    return PlayEngineAnswer(
      PlayEngineAnswerType.key,
      "X",
    );
  }
}
