import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/timer_state.dart';
import '../../data/models/timer_state.dart';

class TimerOverlay extends ConsumerWidget {
  const TimerOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = TimerState();

    return Column(
      children: [
        // 타이머 디스플레이
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                timerState.displayText,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getStatusText(timerState.status),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // 타이머 컨트롤
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: timerNotifier.start,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('시작'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: timerNotifier.pause,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('일시정지'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: timerNotifier.reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('리셋'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusText(TimerStatus status) {
    switch (status) {
      case TimerStatus.idle:
        return '준비';
      case TimerStatus.running:
        return '집중 중';
      case TimerStatus.paused:
        return '일시정지';
      case TimerStatus.completed:
        return '완료!';
    }
  }
}
