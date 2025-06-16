import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'package:flame/game.dart';
import 'package:catodo/features/game/game_root.dart';

class GameVillageManager {
  static final GameVillageManager _instance = GameVillageManager._internal();
  static GameVillageManager get instance => _instance;
  GameVillageManager._internal();

  onChangeTimerState(TimerStatus status, FlameGame game) {
    final gameRoot = game as GameRoot;
    final cat = gameRoot.gameWorld.cat;
    final spaceMap = gameRoot.gameWorld.spaceMap;

    if (status == TimerStatus.running) {
      cat.dance();
      spaceMap.setBaseVelocity(Vector2(40, 0));
    } else {
      cat.sleep();
      spaceMap.setBaseVelocity(Vector2(0, 0));
    }
  }
}
