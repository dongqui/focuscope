import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'components/game_world.dart';
import 'package:catodo/features/overlays/data/models/timer_state.dart';
import 'components/game_manager.dart';
import 'events/game_event_bus.dart';

class GameRoot extends FlameGame
    with
        ScrollDetector,
        ScaleDetector,
        TapDetector,
        RiverpodGameMixin,
        SingleGameInstance {
  late final GameWorld gameWorld;
  late final CameraComponent gameCamera;
  late final GameManager gameManager;
  final _eventBus = GameEventBus();

  // 줌 관련 설정
  static const double minZoom = 0.5;
  static const double maxZoom = 2.0;
  static const double defaultZoom = 1.0;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 게임 매니저 추가
    gameManager = GameManager();
    await add(gameManager);

    // 게임 월드 설정
    gameWorld = GameWorld();
    gameCamera = CameraComponent(
      world: gameWorld,
    )..viewfinder.anchor = Anchor.center;
    gameCamera.viewfinder.zoom = defaultZoom;

    // 컴포넌트 추가
    await addAll([gameWorld, gameCamera]);
  }

  @override
  void onMount() {
    super.onMount();
    addToGameWidgetBuild(() {
      // 이벤트 구독 설정
      _eventBus.stream.listen((event) {
        if (event is TimerStateChangedEvent) {
          _handleTimerStateChanged(event.state);
        }
      });
    });
  }

  void _handleTimerStateChanged(TimerState state) {
    if (state.status == TimerStatus.idle) {
      overlays.removeAll(['home', 'timer']);
      overlays.add('home');
    } else if (state.status == TimerStatus.paused ||
        state.status == TimerStatus.running) {
      overlays.removeAll(['home', 'timer']);
      overlays.add('timer');
    }
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = gameCamera.viewfinder.zoom;
    final scaledDelta = info.delta.global;
    final newScale =
        (currentScale * (1 + scaledDelta.y / 100)).clamp(minZoom, maxZoom);
    gameCamera.viewfinder.zoom = newScale;
  }

  // 오버레이에서 GameManager에 접근하기 위한 메서드
  GameManager get gameState => gameManager;

  // 오버레이에서 이벤트를 발생시키기 위한 메서드
  void emitGameEvent(GameEvent event) {
    _eventBus.emit(event);
  }
}
