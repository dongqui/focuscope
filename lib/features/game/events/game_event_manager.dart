import 'package:catodo/features/game/game_overlay_manager.dart';
import 'package:flame/components.dart';
import 'game_event_bus.dart';
import 'package:catodo/features/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/game/game_world_manager.dart';
import 'package:catodo/features/presentation/viewmodels/characater_state.dart';

class GameEventManager extends Component with HasGameReference {
  final _gameEventBus = GameEventBus.instance;
  final _timerManager = TimerManager.instance;
  final _overlayManager = GameOverlayManager.instance;
  final _worldManager = GameWorldManager.instance;
  final _characterManager = CharacterManager.instance;

  @override
  Future<void> onLoad() async {
    _timerManager.addListenerToStatus(_handleTimerStateChanged);
    _characterManager.addListener(_handleCharacterChanged,
        filter: (state, lastState) =>
            state.selectedCharacter != lastState?.selectedCharacter);
    _gameEventBus.stream.listen(_handleGameEvent);
  }

  void _handleTimerStateChanged(TimerStatus status) {
    _overlayManager.onChangeTimerState(status, game);
    _worldManager.onChangeTimerState(status, game);
  }

  void _handleCharacterChanged(CharacterState state) {
    _worldManager.onChangeCharacter(state.selectedCharacter!, game);
  }

  void _handleGameEvent(GameEvent event) {}
}
