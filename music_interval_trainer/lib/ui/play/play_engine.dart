import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/configuration.dart';

import '../../common/environment/keys_manager.dart';

class PlayEngine {
  final Configuration _configuration;
  final List<String> _keyLabels;

  PlayEngine(BuildContext context, Configuration configuration)
      : _configuration = configuration,
        _keyLabels = KeysManager(context).getList();
}
