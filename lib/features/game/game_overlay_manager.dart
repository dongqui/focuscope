import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'package:flame/game.dart';

enum GameOverlay {
  home,
  timer,
}

class GameOverlayManager {
  static final GameOverlayManager _instance = GameOverlayManager._internal();
  static GameOverlayManager get instance => _instance;
  GameOverlayManager._internal();

  onChangeTimerState(TimerStatus status, FlameGame game) {
    game.overlays
      ..clear()
      ..add(status == TimerStatus.idle
          ? GameOverlay.home.name
          : GameOverlay.timer.name);
  }
}
