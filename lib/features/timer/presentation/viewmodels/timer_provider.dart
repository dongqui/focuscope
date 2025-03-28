import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/timer_state.dart';
import 'dart:async';

class TimerNotifier extends StateNotifier<TimerState> {
  static const int defaultWorkTime = 25 * 60; // 25분
  static const int defaultBreakTime = 5 * 60; // 5분
  late Timer timer;

  TimerNotifier()
      : super(const TimerState(
          remainingTime: defaultWorkTime,
          status: TimerStatus.idle,
          totalTime: defaultWorkTime,
        ));

  void start() {
    if (state.status == TimerStatus.idle ||
        state.status == TimerStatus.paused) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        updateRemainingTime();
      });
      state = state.copyWith(status: TimerStatus.running);
    }
  }

  void pause() {
    if (state.status == TimerStatus.running) {
      state = state.copyWith(status: TimerStatus.paused);
      timer.cancel();
    }
  }

  void reset() {
    state = const TimerState(
      remainingTime: defaultWorkTime,
      status: TimerStatus.idle,
      totalTime: defaultWorkTime,
    );
    timer.cancel();
  }

  void updateRemainingTime() {
    final newRemainingTime = state.remainingTime - 1;
    if (newRemainingTime <= 0) {
      state = state.copyWith(
        remainingTime: 0,
        status: TimerStatus.completed,
      );
    } else {
      state = state.copyWith(remainingTime: newRemainingTime);
    }
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});
