import 'package:catodo/features/data/models/character.dart';
import 'package:catodo/features/presentation/viewmodels/timer_state.dart';
import 'package:flame/game.dart';
import 'package:catodo/features/game/game_root.dart';

class GameWorldManager {
  static final GameWorldManager _instance = GameWorldManager._internal();
  static GameWorldManager get instance => _instance;
  GameWorldManager._internal();

  onChangeTimerState(TimerStatus status, FlameGame game) async {
    final gameRoot = game as GameRoot;

    if (status == TimerStatus.idle) {
      gameRoot.addHomeWorld();
    } else if (status == TimerStatus.ready) {
      await gameRoot.addTimerWorld();
      // gameRoot.pauseTimerWorld();
    } else if (status == TimerStatus.running) {
      await gameRoot.addTimerWorld();
      gameRoot.startTimerWorld();
    } else if (status == TimerStatus.paused) {
      gameRoot.pauseTimerWorld();
    } else if (status == TimerStatus.end) {}
  }

  onChangeCharacter(Character character, FlameGame game) {
    final gameRoot = game as GameRoot;
    gameRoot.setCurrentCharacter(character);
  }
}
