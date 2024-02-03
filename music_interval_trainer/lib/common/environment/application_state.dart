import 'package:flutter/material.dart';

class ApplicationState with WidgetsBindingObserver {
  bool _isActive = true;
  final VoidCallback _onActivate;
  final VoidCallback _onDeactivate;

  bool get isActive => _isActive;

  ApplicationState(this._onActivate, this._onDeactivate);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        if (_isActive) {
          _isActive = false;
          _onDeactivate();
        }

        break;

      case AppLifecycleState.resumed:
        if (!_isActive) {
          _isActive = true;
          _onActivate();
        }

        break;
    }
  }

  ApplicationState register() {
    WidgetsBinding.instance.addObserver(this);
    return this;
  }

  ApplicationState unregister() {
    WidgetsBinding.instance.removeObserver(this);
    return this;
  }
}
