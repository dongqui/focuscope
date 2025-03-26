enum TimerStatus { idle, running, paused, completed }

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

  String get displayText {
    final minutes = (remainingTime / 60).floor();
    final seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress => 1 - (remainingTime / totalTime);
}
