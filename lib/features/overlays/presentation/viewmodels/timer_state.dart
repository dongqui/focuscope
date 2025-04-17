import 'dart:async';

import 'package:catodo/constants/index.dart';

enum TimerStatus {
  idle,
  running,
  paused,
  input,
  end,
}

class TimerState {
  final int focussedTime;
  final TimerStatus status;
  final int goalTime;

  const TimerState({
    required this.focussedTime,
    required this.status,
    required this.goalTime,
  });

  TimerState copyWith({
    int? focussedTime,
    TimerStatus? status,
    int? goalTime,
  }) {
    return TimerState(
      focussedTime: focussedTime ?? this.focussedTime,
      status: status ?? this.status,
      goalTime: goalTime ?? this.goalTime,
    );
  }
}

class TimerManager {
  static final TimerManager _instance = TimerManager._internal();
  static TimerManager get instance => _instance;

  late Timer _timer;
  TimerState _state;
  late TimerStatus _prevStatus = TimerStatus.idle;

  final List<void Function(TimerState)> _listeners = [];
  final List<void Function(TimerStatus)> _listenersToStatus = [];

  TimerManager._internal()
      : _state = const TimerState(
          focussedTime: 0,
          status: TimerStatus.idle,
          goalTime: DEFAULT_WORK_TIME,
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updatefocussedTime();
    });
    _updateState(_state.copyWith(status: TimerStatus.running));
  }

  void readyToFocus() {
    _updateState(_state.copyWith(status: TimerStatus.input));
  }

  void pause() {
    if (_state.status == TimerStatus.running) {
      _updateState(_state.copyWith(status: TimerStatus.paused));
      _timer.cancel();
    }
  }

  void finish() {
    _timer.cancel();
    _updateState(const TimerState(
      focussedTime: 0,
      status: TimerStatus.end,
      goalTime: DEFAULT_WORK_TIME,
    ));
  }

  void save() {
    _updateState(_state.copyWith(
      status: TimerStatus.input,
      focussedTime: 0,
      goalTime: DEFAULT_WORK_TIME,
    ));
  }

  void cancel() {
    _updateState(_state.copyWith(status: TimerStatus.idle));
  }

  void updateGoalTime(int goalTime) {
    _updateState(_state.copyWith(goalTime: goalTime));
  }

  void _updatefocussedTime() {
    final newfocussedTime = _state.focussedTime + 1;
    if (newfocussedTime >= _state.goalTime) {
      _updateState(_state.copyWith(
        status: TimerStatus.end,
      ));
    } else {
      _updateState(_state.copyWith(focussedTime: newfocussedTime));
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
