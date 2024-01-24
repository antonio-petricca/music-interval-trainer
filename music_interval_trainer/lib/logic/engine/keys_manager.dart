import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KeysManager {
  final String _keys;
  List<String> _keyList = [];

  KeysManager(BuildContext context)
      : _keys = AppLocalizations.of(context)!.keys {
    _keyList = _keys.split(',');
  }

  List<String> getList() {
    return _keyList;
  }

  String getKey(int index) {
    return _keyList[index];
  }
}
