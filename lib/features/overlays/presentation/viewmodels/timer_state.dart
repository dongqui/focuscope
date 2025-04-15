import 'dart:async';

enum TimerStatus {
  idle,
  running,
  paused,
  completed,
}

class TimerState {
  final int remainingTime;
  final TimerStatus status;
  final int totalTime;

  const TimerState({
    required this.remainingTime,
    required this.status,
    required this.totalTime,
  });

  TimerState copyWith({
    int? remainingTime,
    TimerStatus? status,
    int? totalTime,
  }) {
    return TimerState(
      remainingTime: remainingTime ?? this.remainingTime,
      status: status ?? this.status,
      totalTime: totalTime ?? this.totalTime,
    );
  }
}

class TimerManager {
  static final TimerManager _instance = TimerManager._internal();
  static TimerManager get instance => _instance;

  static const int defaultWorkTime = 25 * 60; // 25분
  static const int defaultBreakTime = 5 * 60; // 5분
  late Timer _timer;
  TimerState _state;
  late TimerStatus _prevStatus = TimerStatus.idle;

  final List<void Function(TimerState)> _listeners = [];
  final List<void Function(TimerStatus)> _listenersToStatus = [];

  TimerManager._internal()
      : _state = const TimerState(
          remainingTime: defaultWorkTime,
          status: TimerStatus.idle,
          totalTime: defaultWorkTime,
        );

  TimerState get state => _state;

  void addListener(void Function(TimerState) listener) {
    _listeners.add(listener);
  }

  void addListenerToStatus(void Function(TimerStatus) listener) {
    _listenersToStatus.add(listener);
  }

  void removeListener(void Function(TimerState) listener) {
    _listeners.remove(listener);
  }

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
    for (final listener in _listeners) {
      listener(_state);
    }

    if (_state.status != _prevStatus) {
      _prevStatus = newState.status;

      for (final listener in _listenersToStatus) {
        listener(_state.status);
      }
    }
  }

  void dispose() {
    _timer.cancel();
    _listeners.clear();
    _listenersToStatus.clear();
  }
}
