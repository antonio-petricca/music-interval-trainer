import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// https://chat.openai.com/share/dd0541ce-cfcd-4e65-ac80-6007360b7e8d

class Configuration {
  late Map<String, dynamic> _config;

  Future<Map<String, dynamic>> load() async {
    return rootBundle
        .loadString('assets/config.json')
        .then(
          (configFile) => _parseConfig(configFile),
        )
        .catchError((error) {
      throw Exception(error);
    });
  }

  Map<String, dynamic> _parseConfig(String configFile) {
    return json.decode(configFile);
  }
}
