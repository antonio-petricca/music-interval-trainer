import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Configuration {
  Map<String, dynamic>? _configuration;

  Future<void> load(BuildContext context) async {
    String configFile = await DefaultAssetBundle.of(context).loadString("assets/configuration.json");

    _configuration = json.decode(configFile);
  }

  dynamic get(String propertyName, dynamic defaultValue ) {
    if (null != _configuration) {
      return _configuration?[propertyName];
    }

    return defaultValue;
  }
}
