import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components.dart';

class CatCharacter2 extends SpriteComponent with HasGameRef {
  double _elapsedTime = 0; // 시간 추적 변수

  @override
  Future<void> onLoad() async {
    // 고양이 이미지 로드
    final catImage = await gameRef.images.load('cat/cat.png');
    sprite = Sprite(catImage);
    size = Vector2.all(256);
    position = Vector2(100, 400); // 시작 위치(원하는 위치로 조정)
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;
    // sin 함수를 이용해 y좌표를 위아래로 움직임 (진폭 20, 속도 2)
    position.y = 300 + 20 * (math.sin(_elapsedTime * 2));
  }
}
