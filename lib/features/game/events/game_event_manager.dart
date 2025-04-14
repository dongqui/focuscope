import 'package:catodo/features/game/game_overlay_manager.dart';
import 'package:flame/components.dart';
import 'game_event_bus.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/game/game_root.dart';

class GameEventManager extends Component with HasGameRef<GameRoot> {
  final _gameEventBus = GameEventBus.instance;
  final _timerManager = TimerManager.instance;
  final _overlayManager = GameOverlayManager.instance;

  @override
  Future<void> onLoad() async {
    _timerManager.addListener(_handleTimerStateChanged);
    _gameEventBus.stream.listen(_handleGameEvent);
  }

  void _handleTimerStateChanged(TimerState state) {
    _overlayManager.onChangeTimerState(state, gameRef);
  }

  void _handleGameEvent(GameEvent event) {}
}
