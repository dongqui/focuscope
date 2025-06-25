import 'dart:ui';

import 'package:flame/components.dart';
import 'dart:math' as math;

class Travller extends SpriteAnimationComponent with HasGameReference {
  double _elapsedTime = 0;

  @override
  Future<void> onLoad() async {
    final dogSpriteSheet = await game.images.load('traveller_sprites.png');
    final frames = [0, 1, 2, 3, 2, 1, 0]
        .map((index) => Sprite(
              dogSpriteSheet,
              srcSize: Vector2(256, 256),
              srcPosition: Vector2(index * 256, 0),
            ))
        .toList();
    animation = SpriteAnimation.spriteList(
      frames,
      stepTime: 0.2,
    );
    size = Vector2(128, 128);
    position = Vector2((game.size.x / 2 - 64), game.size.y / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;
    // sin 함수를 이용해 y좌표를 위아래로 움직임 (진폭 20, 속도 2)
    position.y = (game.size.y / 2) + 20 * (math.sin(_elapsedTime * 2));
  }

  void removeAnimation() {
    animation = null;
  }
}
