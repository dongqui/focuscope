import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'world/game_world.dart';
import '../timer/domain/timer_service.dart';

class CatodoGame extends FlameGame
    with ScrollDetector, ScaleDetector, TapDetector {
  late final GameWorld gameWorld;
  late final CameraComponent gameCamera;
  late final TimerService timerService;

  // 줌 관련 설정
  static const double minZoom = 0.5;
  static const double maxZoom = 2.0;
  static const double defaultZoom = 1.0;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 서비스 초기화
    timerService = TimerService();

    // 게임 월드 설정
    gameWorld = GameWorld();
    gameCamera = CameraComponent(
      world: gameWorld,
    )..viewfinder.anchor = Anchor.center;
    gameCamera.viewfinder.zoom = defaultZoom;

    // 컴포넌트 추가
    addAll([gameWorld, gameCamera]);

    // 오버레이 추가
    overlays.add('timer');
  }

  @override
  void update(double dt) {
    super.update(dt);
    timerService.update(dt);

    // 타이머 상태에 따른 고양이 상태 업데이트
    _updateCatState();
  }

  void _updateCatState() {
    switch (timerService.state.status) {
      case TimerStatus.running:
        gameWorld.cat.startDancing();
        break;
      case TimerStatus.idle:
      case TimerStatus.paused:
      case TimerStatus.completed:
        gameWorld.cat.stopDancing();
        break;
    }
  }

  // 타이머 제어 메서드
  void startTimer() => timerService.start();
  void pauseTimer() => timerService.pause();
  void resetTimer() => timerService.reset();

  // 타이머 상태 접근자
  String get timerText => timerService.state.displayText;
  TimerState get timerState => timerService.state;

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = gameCamera.viewfinder.zoom;
    final scaledDelta = info.delta.global;
    final newScale =
        (currentScale * (1 + scaledDelta.y / 100)).clamp(minZoom, maxZoom);
    gameCamera.viewfinder.zoom = newScale;
  }
}
