import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

class SpaceMap extends Component {
  late final ParallaxComponent _parallaxComponent;

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
    final layers = await Future.wait(
      _layersMeta.entries.map((entry) async {
        final image = await ParallaxImageData(entry.key).load(
          ImageRepeat.repeatX,
          Alignment.bottomLeft,
          LayerFill.height,
          null,
          FilterQuality.none,
        );
        return ParallaxLayer(
          image,
          velocityMultiplier: Vector2(entry.value, 1.0),
        );
      }),
    );

    _parallaxComponent = ParallaxComponent(
      parallax: Parallax(
        layers,
        baseVelocity: Vector2(20, 0),
      ),
    );

    add(_parallaxComponent);
  }

  pause() {
    _parallaxComponent.parallax?.baseVelocity = Vector2(0, 0);
  }

  resume() {
    _parallaxComponent.parallax?.baseVelocity = Vector2(20, 0);
  }
}
