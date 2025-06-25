import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'components/home/home_world.dart';
import 'events/game_event_manager.dart';
import 'components/game_world.dart';

class GameRoot extends FlameGame
    with SingleGameInstance, MultiTouchDragDetector {
  late final HomeWorld homeWorld;
  late final CameraComponent gameCamera;
  late final GameEventManager gameEventManager;
  late final GameWorld gameWorld;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 7, 7, 7);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 게임 매니저 추가
    gameEventManager = GameEventManager();
    // 게임 월드 설정
    homeWorld = HomeWorld();
    gameWorld = GameWorld();

    // 카메라 설정
    gameCamera = CameraComponent(
      world: homeWorld,
    )..viewfinder.anchor = Anchor.topLeft;

    // 컴포넌트 추가
    await addAll([homeWorld, gameCamera, gameEventManager, gameWorld]);
  }

  addHomeWorld() {
    removeAll([gameWorld]);
    addAll([homeWorld]);

    gameCamera.world = homeWorld;
  }

  addGameWorld() {
    removeAll([homeWorld]);
    addAll([gameWorld]);

    gameCamera.world = gameWorld;
  }

  // @override
  // void onDragUpdate(int pointerId, DragUpdateInfo info) {
  //   final globalDelta = info.delta.global;
  //   final localDelta = gameCamera.viewfinder.globalToLocal(Vector2.zero()) -
  //       gameCamera.viewfinder.globalToLocal(globalDelta);

  //   gameCamera.moveBy(localDelta);
  // }
}
