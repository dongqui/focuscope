import 'dart:async';
import 'package:catodo/features/overlays/data/models/timer_state.dart';

// 게임 이벤트 기본 클래스
abstract class GameEvent {}

// 타이머 상태 변경 이벤트
class TimerStateChangedEvent extends GameEvent {
  final TimerState state;
  TimerStateChangedEvent(this.state);
}

// 타이머 액션 이벤트
class TimerActionEvent extends GameEvent {
  final TimerAction action;
  TimerActionEvent(this.action);
}

// 타이머 액션 타입
enum TimerAction {
  start,
  pause,
  reset,
}

// 이벤트 버스 싱글톤
class GameEventBus {
  static final GameEventBus _instance = GameEventBus._internal();
  factory GameEventBus() => _instance;
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
