import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/common/environment/configuration_catalog.dart';

class Configuration {
  Map<String, dynamic>? _configuration;

  int _intervalsSpeedMaxSeconds = -1;
  int _intervalsSpeedMinSeconds = -1;
  int _playCountdownTimeout = -1;
  String _supportEmail = "";

  int get intervalsSpeedMaxSeconds => _intervalsSpeedMaxSeconds;

  int get intervalsSpeedMinSeconds => _intervalsSpeedMinSeconds;

  int get playCountdownTimeout => _playCountdownTimeout;

  String get supportEmail => _supportEmail;

  Future<void> load(BuildContext context) async {
    String configFile = await DefaultAssetBundle.of(context).loadString("assets/configuration.json");

    _configuration = json.decode(configFile);

    _intervalsSpeedMaxSeconds = _get(ConfigurationCatalog.intervalsSpeedMaxSeconds);
    _intervalsSpeedMinSeconds = _get(ConfigurationCatalog.intervalsSpeedMinSeconds);
    _playCountdownTimeout = _get(ConfigurationCatalog.playCountdownTimeout);
    _supportEmail = _get(ConfigurationCatalog.supportEmail);
  }

  dynamic _get(String propertyName) {
    return _configuration?[propertyName];
  }
}
