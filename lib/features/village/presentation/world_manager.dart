import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:ui'; // Color를 위한 import 추가
import 'catodo_world.dart';

class CatodoGame extends FlameGame with ScrollDetector, ScaleDetector {
  late final CatodoWorld catodoWorld;
  late final CameraComponent cameraComponent;

  // 줌 관련 설정
  static const double minZoom = 0.5;
  static const double maxZoom = 2.0;
  static const double defaultZoom = 1.0;

  @override
  Color backgroundColor() => const Color(0xFF211F30); // 배경색 설정

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 게임 월드 생성
    catodoWorld = CatodoWorld();

    // 카메라 설정
    cameraComponent = CameraComponent(
      world: catodoWorld,
    )..viewfinder.anchor = Anchor.center;

    // 기본 줌 레벨 설정
    cameraComponent.viewfinder.zoom = defaultZoom;

    // 게임에 추가
    addAll([catodoWorld, cameraComponent]);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = cameraComponent.viewfinder.zoom;
    final scaledDelta = info.delta.global;
    final newScale =
        (currentScale * (1 + scaledDelta.y / 100)).clamp(minZoom, maxZoom);
    cameraComponent.viewfinder.zoom = newScale;
  }
}
