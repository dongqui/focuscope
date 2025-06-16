import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'components/game_world.dart';
import 'events/game_event_manager.dart';

class GameRoot extends FlameGame
    with SingleGameInstance, MultiTouchDragDetector {
  late final GameWorld gameWorld;
  late final CameraComponent gameCamera;
  late final GameEventManager gameEventManager;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 게임 매니저 추가
    gameEventManager = GameEventManager();
    // 게임 월드 설정
    gameWorld = GameWorld();

    // 카메라 설정
    gameCamera = CameraComponent(
      world: gameWorld,
    )..viewfinder.anchor = Anchor.topLeft;

    // 컴포넌트 추가
    await addAll([gameWorld, gameCamera, gameEventManager]);
  }

  // @override
  // void onDragUpdate(int pointerId, DragUpdateInfo info) {
  //   final globalDelta = info.delta.global;
  //   final localDelta = gameCamera.viewfinder.globalToLocal(Vector2.zero()) -
  //       gameCamera.viewfinder.globalToLocal(globalDelta);

  //   gameCamera.moveBy(localDelta);
  // }
}
