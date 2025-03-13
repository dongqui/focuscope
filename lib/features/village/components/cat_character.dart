import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class CatCharacter extends SpriteAnimationComponent with HasGameRef {
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _walkAnimation;
  bool _isWalking = false;

  @override
  Future<void> onLoad() async {
    // 스프라이트 시트 로드
    final spriteSheet = await gameRef.images.load('cat_sprite.webp');

    // idle 애니메이션 설정 (4프레임)
    _idleAnimation = SpriteAnimation.spriteList(
      List.generate(
          4,
          (index) => Sprite(
                spriteSheet,
                srcSize: Vector2(32, 32),
                srcPosition: Vector2(index * 32, 0),
              )),
      stepTime: 0.2,
    );

    // walk 애니메이션 설정 (6프레임)
    _walkAnimation = SpriteAnimation.spriteList(
      List.generate(
          6,
          (index) => Sprite(
                spriteSheet,
                srcSize: Vector2(32, 32),
                srcPosition: Vector2(index * 32, 32),
              )),
      stepTime: 0.15,
    );

    // 기본 크기 설정
    size = Vector2.all(32);

    // 초기 애니메이션 설정
    animation = _idleAnimation;
  }

  void startWalking() {
    if (!_isWalking) {
      _isWalking = true;
      animation = _walkAnimation;
    }
  }

  void stopWalking() {
    if (_isWalking) {
      _isWalking = false;
      animation = _idleAnimation;
    }
  }

  void moveTo(Vector2 target) {
    startWalking();
    // 목표 지점으로 이동하는 로직
    position = target;
  }
}
