import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../game/catodo_game.dart';
import '../../data/models/timer_state.dart';

class TimerOverlay extends StatelessWidget {
  final CatodoGame game;

  const TimerOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: game.timerProvider,
      builder: (context, child) {
        final state = game.timerProvider.state;

        return Column(
          children: [
            // 타이머 디스플레이
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    state.displayText,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStatusText(state.status),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // 타이머 컨트롤
            Positioned(
              bottom: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: game.startTimer,
                    child: const Text('시작'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: game.pauseTimer,
                    child: const Text('일시정지'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: game.resetTimer,
                    child: const Text('리셋'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
