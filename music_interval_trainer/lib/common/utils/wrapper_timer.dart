import 'dart:async';
import 'dart:io';

import 'constants.dart';

typedef OnPlayTimerTimeout = bool Function(WrapperTimer timer);

class WrapperTimer {
  final bool _fireImmediately;
  final Duration _interval;
  bool _isRunning = false;
  Timer? _timer;

  Duration get interval => _interval;

  bool get isRunning => _isRunning;
  OnPlayTimerTimeout onTimerElapsed;

  WrapperTimer(
    this._interval,
    this._fireImmediately,
    this.onTimerElapsed,
  );

  bool start() {
    if (isRunning || (Duration.zero == _interval)) {
      return false;
    }

    _isRunning = true;

    if (_fireImmediately) {
      _doOnTimerElapsed();
    } else {
      _doStart();
    }

    return true;
  }

  bool stop() {
    if (!isRunning) {
      return false;
    }

    _doStop();

    _isRunning = false;

    return true;
  }

  void _doStart() {
    _timer = Timer.periodic(_interval, _onTimerElapsed);
  }

  void _doStop() {
    _timer!.cancel();

    while (_timer!.isActive) {
      sleep(Constants.oneMillisecond);
    }
  }

  void _doOnTimerElapsed() {
    if (isRunning) {
      if (onTimerElapsed(this)) {
        _doStart();
      }
    }
  }

  void _onTimerElapsed(Timer timer) {
    _doStop();
    _doOnTimerElapsed();
  }
}
