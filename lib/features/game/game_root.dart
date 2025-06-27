import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'components/home/home_world.dart';
import 'events/game_event_manager.dart';
import 'components/timer/timer_world.dart';
import 'package:catodo/features/characters/data/models/character.dart';

class GameRoot extends FlameGame
    with SingleGameInstance, MultiTouchDragDetector {
  late final HomeWorld homeWorld;
  late final CameraComponent gameCamera;
  late final GameEventManager gameEventManager;
  late final TimerWorld timerWorld;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 7, 7, 7);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 게임 매니저 추가
    gameEventManager = GameEventManager();
    // 게임 월드 설정
    homeWorld = HomeWorld();
    timerWorld = TimerWorld();

    // 카메라 설정
    gameCamera = CameraComponent(world: homeWorld)
      ..viewfinder.anchor = Anchor.topLeft;

    // 컴포넌트 추가
    await addAll([homeWorld, gameCamera, gameEventManager]);
  }

  void setCurrentCharacter(Character character) {
    homeWorld.setTraveller(character);
    timerWorld.setTraveller(character);
  }

  addHomeWorld() async {
    if (children.contains(timerWorld)) {
      remove(timerWorld);
    }
    if (!children.contains(homeWorld)) {
      await add(homeWorld);
    }
    gameCamera.world = homeWorld;
  }

  startTimerWorld() async {
    timerWorld.resume();
  }

  pauseTimerWorld() async {
    timerWorld.pause();
  }

  addTimerWorld() async {
    if (children.contains(homeWorld)) {
      remove(homeWorld);
    }
    if (!children.contains(timerWorld)) {
      await add(timerWorld);
    }
    gameCamera.world = timerWorld;
  }
}
