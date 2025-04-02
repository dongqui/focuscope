import 'package:flame/components.dart';
import '../events/game_event_bus.dart';

class GameManager extends Component {
  final _eventBus = GameEventBus();

  @override
  Future<void> onLoad() async {
    _eventBus.stream.listen(_handleEvent);
  }

  void _handleEvent(GameEvent event) {
    // 이벤트를 그대로 전달
    _eventBus.emit(event);
  }

  // 외부에서 이벤트를 발생시킬 수 있는 메서드
  void emitEvent(GameEvent event) {
    _eventBus.emit(event);
  }
}
