import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Configuration {
  late Map<String, dynamic> _configuration;

  Future<void> load(BuildContext context) async {
    String configFile =
        await DefaultAssetBundle.of(context).loadString("assets/configuration.json");

    _configuration = json.decode(configFile);
  }

  dynamic get(String propertyName) {
    WidgetsFlutterBinding.ensureInitialized();

    return _configuration[propertyName];
  }
}
