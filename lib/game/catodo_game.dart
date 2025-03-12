import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:ui'; // Color를 위한 import 추가
import 'components/village_map.dart';

class CatodoGame extends FlameGame {
  late final World gameWorld;
  late final CameraComponent cameraComponent;

  @override
  Color backgroundColor() => const Color(0xFF211F30); // 배경색 설정

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 월드 생성
    gameWorld = World();

    // 맵 생성 및 월드에 추가
    final villageMap = VillageMap();
    gameWorld.add(villageMap);

    // 카메라 설정
    cameraComponent = CameraComponent(
      world: gameWorld,
    )..viewfinder.anchor = Anchor.center;

    // 화면에 맞게 줌 레벨 조정
    final screenWidth = size.x;
    final screenHeight = size.y;
    final zoom = (screenWidth / (50 * 32)).clamp(0.1, 2.0);
    cameraComponent.viewfinder.zoom = zoom;

    // 게임에 카메라와 월드 추가
    addAll([cameraComponent, gameWorld]);
  }
}
