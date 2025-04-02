import 'package:flutter/material.dart';
import 'package:catodo/features/game/game_root.dart';
import 'package:catodo/features/overlays/data/models/timer_state.dart';
import 'package:catodo/features/game/events/game_event_bus.dart';

class TimerOverlay extends StatelessWidget {
  final GameRoot game;

  const TimerOverlay(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameEvent>(
      stream: GameEventBus().stream,
      builder: (context, snapshot) {
        final gameState = game.gameState.currentState;

        return _buildTimerUI(context, gameState);
      },
    );
  }

  Widget _buildTimerUI(BuildContext context, TimerState state) {
    final minutes = (state.remainingTime / 60).floor();
    final seconds = state.remainingTime % 60;
    final formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formattedTime,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.status == TimerStatus.running)
                _buildButton(
                  context,
                  '일시정지',
                  Icons.pause,
                  () => game.emitGameEvent(TimerActionEvent(TimerAction.pause)),
                )
              else if (state.status == TimerStatus.paused)
                _buildButton(
                  context,
                  '재시작',
                  Icons.play_arrow,
                  () => game.emitGameEvent(TimerActionEvent(TimerAction.start)),
                ),
              const SizedBox(width: 20),
              _buildButton(
                context,
                '초기화',
                Icons.refresh,
                () => game.emitGameEvent(TimerActionEvent(TimerAction.reset)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
