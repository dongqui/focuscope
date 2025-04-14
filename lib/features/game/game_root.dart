import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'components/game_world.dart';
import 'events/game_event_manager.dart';

class GameRoot extends FlameGame
    with
        ScrollDetector,
        ScaleDetector,
        TapDetector,
        RiverpodGameMixin,
        SingleGameInstance {
  late final GameWorld gameWorld;
  late final CameraComponent gameCamera;
  late final GameEventManager gameEventManager;

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
    gameEventManager = GameEventManager();
    // 게임 월드 설정
    gameWorld = GameWorld();
    gameCamera = CameraComponent(
      world: gameWorld,
    )..viewfinder.anchor = Anchor.center;
    gameCamera.viewfinder.zoom = defaultZoom;

    // 컴포넌트 추가
    await addAll([gameEventManager, gameWorld, gameCamera]);
  }

  @override
  void onMount() {
    super.onMount();
    addToGameWidgetBuild(() {
      // 이벤트 구독 설정
    });
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = gameCamera.viewfinder.zoom;
    final scaledDelta = info.delta.global;
    final newScale =
        (currentScale * (1 + scaledDelta.y / 100)).clamp(minZoom, maxZoom);
    gameCamera.viewfinder.zoom = newScale;
  }
}
