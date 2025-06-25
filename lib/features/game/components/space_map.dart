import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

class SpaceMap extends FlameGame {
  late final ParallaxComponent parallaxComponent;

  // @override
  // Future<void> onLoad() async {
  //   // 우주 배경 이미지 로드 및 parallax 설정
  //   _spaceBackground = await ParallaxComponent.load([
  //     ParallaxImageData('universe.webp'),
  //   ],
  //       baseVelocity: Vector2(40, 0), // 가로로 천천히 이동
  //       size: Vector2(2056, 2056));

  //   // 컴포넌트에 추가
  //   add(_spaceBackground);
  // }

  // void setBaseVelocity(Vector2 velocity) {
  //   _spaceBackground.parallax?.baseVelocity = velocity;
  // }
  static const String description = '''
    Shows how to create a parallax with different velocity deltas on each layer.
  ''';

  final _layersMeta = {
    'parallax/stars_top.png': 0.5,
  };

  @override
  Future<void> onLoad() async {
    final layers = _layersMeta.entries.map(
      (e) => loadParallaxLayer(
        ParallaxImageData(e.key),
        velocityMultiplier: Vector2(e.value, 1.0),
        filterQuality: FilterQuality.none,
      ),
    );
    parallaxComponent = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(20, 0),
      ),
    );
    add(parallaxComponent);
  }

  pause() {
    parallaxComponent.parallax?.baseVelocity = Vector2(0, 0);
  }

  resume() {
    parallaxComponent.parallax?.baseVelocity = Vector2(20, 0);
  }
}
