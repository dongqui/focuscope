import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'dart:math' as math;

class CatCharacter extends SpriteAnimationComponent with HasGameRef {
  late final SpriteAnimation _danceAnimation;
  bool _isDancing = false;

  @override
  Future<void> onLoad() async {
    // 스프라이트 시트 로드
    final spriteSheet = await gameRef.images.load('cat/Cats/Sprites/Dance.png');

    // 춤추는 애니메이션 설정 (4프레임)
    _danceAnimation = SpriteAnimation.spriteList(
      List.generate(
          4,
          (index) => Sprite(
                spriteSheet,
                srcSize: Vector2(64, 64),
                srcPosition: Vector2(index * 64, 0),
              )),
      stepTime: 0.2,
    );

    // 캐릭터 크기 설정 (화면에 표시될 크기)
    size = Vector2.all(64);

    // 고양이를 바로 세우기 위해 90도 회전
    angle = -math.pi / 2;

    // 초기 애니메이션 설정
    animation = _danceAnimation;
  }

  void startDancing() {
    if (!_isDancing) {
      _isDancing = true;
      animation = _danceAnimation;
    }
  }

  void stopDancing() {
    if (_isDancing) {
      _isDancing = false;
      animation = null;
    }
  }
}
