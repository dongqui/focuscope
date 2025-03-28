import 'package:catodo/features/timer/presentation/viewmodels/timer_provider.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'components/game_world.dart';
import 'package:catodo/features/timer/data/models/timer_state.dart';

class GameRoot extends FlameGame
    with
        ScrollDetector,
        ScaleDetector,
        TapDetector,
        RiverpodGameMixin,
        SingleGameInstance {
  late final GameWorld gameWorld;
  late final CameraComponent gameCamera;

  // 줌 관련 설정
  static const double minZoom = 0.5;
  static const double maxZoom = 2.0;
  static const double defaultZoom = 1.0;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

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
  void onMount() {
    super.onMount();
    addToGameWidgetBuild(() {
      ref.listen(timerProvider, (previous, next) {
        if (next.status == TimerStatus.idle ||
            next.status == TimerStatus.paused) {
          gameWorld.cat.stopDancing();
        } else if (next.status == TimerStatus.running) {
          gameWorld.cat.startDancing();
        }
      });
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
