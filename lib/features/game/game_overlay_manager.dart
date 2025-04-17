import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'package:flame/game.dart';

enum GameOverlay { home, timer, form, focusEnd }

class GameOverlayManager {
  static final GameOverlayManager _instance = GameOverlayManager._internal();
  static GameOverlayManager get instance => _instance;
  GameOverlayManager._internal();

  onChangeTimerState(TimerStatus status, FlameGame game) {
    game.overlays.clear();
    if (status == TimerStatus.idle) {
      game.overlays.add(GameOverlay.home.name);
    } else if (status == TimerStatus.running || status == TimerStatus.paused) {
      game.overlays.add(GameOverlay.timer.name);
    } else if (status == TimerStatus.input) {
      game.overlays.add(GameOverlay.form.name);
    } else if (status == TimerStatus.end) {
      game.overlays.add(GameOverlay.focusEnd.name);
    }
  }
}
