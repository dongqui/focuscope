import '../../data/models/timer_state.dart';
import 'dart:async';

class TimerManager {
  static const int defaultWorkTime = 25 * 60; // 25분
  static const int defaultBreakTime = 5 * 60; // 5분
  late Timer _timer;
  TimerState _state;

  // 상태 변경 콜백
  final void Function(TimerState) onStateChanged;

  TimerManager({required this.onStateChanged})
      : _state = const TimerState(
          remainingTime: defaultWorkTime,
          status: TimerStatus.idle,
          totalTime: defaultWorkTime,
        );

  TimerState get state => _state;

  void start() {
    if (_state.status == TimerStatus.idle ||
        _state.status == TimerStatus.paused) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateRemainingTime();
      });
      _updateState(_state.copyWith(status: TimerStatus.running));
    }
  }

  void pause() {
    if (_state.status == TimerStatus.running) {
      _updateState(_state.copyWith(status: TimerStatus.paused));
      _timer.cancel();
    }
  }

  void reset() {
    _timer.cancel();
    _updateState(const TimerState(
      remainingTime: defaultWorkTime,
      status: TimerStatus.idle,
      totalTime: defaultWorkTime,
    ));
  }

  void _updateRemainingTime() {
    final newRemainingTime = _state.remainingTime - 1;
    if (newRemainingTime <= 0) {
      _updateState(_state.copyWith(
        remainingTime: 0,
        status: TimerStatus.completed,
      ));
    } else {
      _updateState(_state.copyWith(remainingTime: newRemainingTime));
    }
  }

  void _updateState(TimerState newState) {
    _state = newState;
    onStateChanged(_state);
  }

  void dispose() {
    _timer.cancel();
  }
}
