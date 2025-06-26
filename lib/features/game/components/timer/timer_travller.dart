import '../traveller.dart';
import 'dart:math' as math;
import 'package:flame/components.dart';

class TimerTraveller extends Traveller {
  TimerTraveller({required super.imagePath, required super.frames});
  double _elapsedTime = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(128, 128);
    position.x = game.size.x / 2 - 64;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;
    // sin 함수를 이용해 y좌표를 위아래로 움직임 (진폭 20, 속도 2)
    position.y = (game.size.y / 2) + 20 * (math.sin(_elapsedTime * 2));
  }
}
