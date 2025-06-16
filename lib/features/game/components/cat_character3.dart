import 'dart:ui';

import 'package:flame/components.dart';
import 'dart:math' as math;

class CatCharacter3 extends SpriteAnimationComponent with HasGameRef {
  // late final SpriteAnimation _danceAnimation;
  // late final SpriteAnimation _sleepingAnimation;

  @override
  Future<void> onLoad() async {
    // // 스프라이트 시트 로드
    // final danceSpriteSheet =
    //     await gameRef.images.load('cat/Cats/Sprites/Dance.png');
    // final sleepingSpriteSheet =
    //     await gameRef.images.load('cat/Cats/Sprites/Sleeping.png');

    // _danceAnimation = createAnimation(danceSpriteSheet);
    // _sleepingAnimation = createAnimation(sleepingSpriteSheet);

    // size = Vector2.all(64);
    // angle = math.pi / 10;
    // animation = _danceAnimation;

    final dogSpriteSheet = await gameRef.images.load('cat/dog_sprites.png');
    animation = SpriteAnimation.spriteList(
      List.generate(
          4,
          (index) => Sprite(
                dogSpriteSheet,
                srcSize: Vector2(256, 256),
                srcPosition: Vector2(index * 256, 0),
              )),
      stepTime: 0.2,
    );
  }

  SpriteAnimation createAnimation(Image image) {
    return SpriteAnimation.spriteList(
      List.generate(
          4,
          (index) => Sprite(
                image,
                srcSize: Vector2(64, 64),
                srcPosition: Vector2(index * 64, 0),
              )),
      stepTime: 0.2,
    );
  }

  void dance() {
    // animation = _danceAnimation;
  }

  void sleep() {
    // animation = _sleepingAnimation;
  }

  void removeAnimation() {
    animation = null;
  }
}
