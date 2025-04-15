import 'package:catodo/features/game/game_overlay_manager.dart';
import 'package:flame/components.dart';
import 'game_event_bus.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/game/game_root.dart';
import 'package:catodo/features/game/game_village_manager.dart';

class GameEventManager extends Component with HasGameRef<GameRoot> {
  final _gameEventBus = GameEventBus.instance;
  final _timerManager = TimerManager.instance;
  final _overlayManager = GameOverlayManager.instance;
  final _villageManager = GameVillageManager.instance;

  @override
  Future<void> onLoad() async {
    _timerManager.addListenerToStatus(_handleTimerStateChanged);
    _gameEventBus.stream.listen(_handleGameEvent);
  }

  void _handleTimerStateChanged(TimerStatus status) {
    _overlayManager.onChangeTimerState(status, gameRef);
    _villageManager.onChangeTimerState(status, gameRef);
  }

  void _handleGameEvent(GameEvent event) {}
}
