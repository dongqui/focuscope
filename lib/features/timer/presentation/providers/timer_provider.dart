import 'package:flutter/foundation.dart';
import '../../data/models/timer_state.dart';

class TimerProvider extends ChangeNotifier {
  static const int defaultWorkTime = 25 * 60; // 25분
  static const int defaultBreakTime = 5 * 60; // 5분

  TimerState _state = TimerState(
    remainingTime: defaultWorkTime,
    status: TimerStatus.idle,
    totalTime: defaultWorkTime,
  );

  TimerState get state => _state;

  void start() {
    if (_state.status == TimerStatus.idle ||
        _state.status == TimerStatus.paused) {
      _state = _state.copyWith(status: TimerStatus.running);
      notifyListeners();
    }
  }

  void pause() {
    if (_state.status == TimerStatus.running) {
      _state = _state.copyWith(status: TimerStatus.paused);
      notifyListeners();
    }
  }

  void reset() {
    _state = TimerState(
      remainingTime: defaultWorkTime,
      status: TimerStatus.idle,
      totalTime: defaultWorkTime,
    );
    notifyListeners();
  }

  void update(double dt) {
    if (_state.status == TimerStatus.running) {
      final newRemainingTime = _state.remainingTime - 1;
      if (newRemainingTime <= 0) {
        _state = _state.copyWith(
          remainingTime: 0,
          status: TimerStatus.completed,
        );
      } else {
        _state = _state.copyWith(remainingTime: newRemainingTime);
      }
      notifyListeners();
    }
  }
}
