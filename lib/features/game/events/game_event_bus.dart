import 'dart:async';

// 게임 이벤트 기본 클래스
abstract class GameEvent {}

// 이벤트 버스 싱글톤
class GameEventBus {
  static final GameEventBus _instance = GameEventBus._internal();
  static GameEventBus get instance => _instance;
  GameEventBus._internal();

  final _controller = StreamController<GameEvent>.broadcast();

  Stream<GameEvent> get stream => _controller.stream;

  void emit(GameEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
