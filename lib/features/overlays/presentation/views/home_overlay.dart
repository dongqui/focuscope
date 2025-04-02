import 'package:flutter/material.dart';
import 'package:catodo/features/game/game_root.dart';
import 'package:catodo/features/game/events/game_event_bus.dart';

class HomeOverlay extends StatelessWidget {
  final GameRoot game;

  const HomeOverlay(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '고양이와 함께하는 타이머',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () =>
                game.emitGameEvent(TimerActionEvent(TimerAction.start)),
            icon: const Icon(Icons.play_arrow),
            label: const Text('타이머 시작'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
