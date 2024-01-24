import 'dart:async';
import 'dart:io';

import '../../common/utils/constants.dart';

typedef OnPlayTimerTimeout = bool Function(PlayTimer timer);

class PlayTimer {
  final _fireImmediately;
  final Duration _interval;
  bool _isRunning = false;
  Timer? _timer;

  Duration get interval => _interval;

  bool get isRunning => _isRunning;
  OnPlayTimerTimeout onTimerElapsed;

  PlayTimer(this._interval,
      this._fireImmediately,
      this.onTimerElapsed,);

  bool start() {
    if (isRunning || (Duration.zero == _interval)) {
      return false;
    }

    _isRunning = true;

    if (_fireImmediately) {
      _doOnTimerElapsed();
    }

    _timer = Timer.periodic(interval, _onTimerElapsed);

    return true;
  }

  bool stop() {
    if (!isRunning) {
      return false;
    }

    _timer!.cancel();

    while (_timer!.isActive) {
      sleep(Constants.oneMillisecond);
    }

    _isRunning = false;

    return true;
  }

  void _doOnTimerElapsed() {
    if (onTimerElapsed(this)) {
      start();
    }
  }

  void _onTimerElapsed(Timer timer) {
    stop();
    _doOnTimerElapsed();
  }
}
