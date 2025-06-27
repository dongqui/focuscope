import 'package:flame/components.dart';
import 'dart:math';

enum FlowStarDirection { left, right }

class FlowStar extends SpriteComponent with HasGameReference {
  late double _elapsed;
  late double _duration;
  late Vector2 _start;
  late Vector2 _end;

  bool _moving = true;
  double _waitTimer = 0;
  double _waitDuration = 0;
  final Random _random = Random();
  final FlowStarDirection _direction;

  FlowStar(this._direction);

  @override
  Future<void> onLoad() async {
    final flowstarSpriteSheet =
        await game.images.load('flowstar_${_direction.name}.png');
    sprite = Sprite(flowstarSpriteSheet);
    size = Vector2(128, 128);
    _resetStar();
  }

  void _resetStar() {
    _elapsed = 0;
    _duration = 0.5; // 0.7~2.2초
    final rnadomStarStart = _random.nextDouble() * game.size.y;
    _start = Vector2(_direction == FlowStarDirection.right ? 0 : game.size.x,
        rnadomStarStart);
    _end = Vector2(
        _direction == FlowStarDirection.right ? game.size.x : 0 - 128,
        rnadomStarStart + game.size.y * 0.4);
    position = _start.clone();
    _moving = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_moving) {
      _elapsed += dt;
      double t = (_elapsed / _duration).clamp(0.0, 1.0);
      position = _start + (_end - _start) * t;
      if (t >= 1.0) {
        _moving = false;
        _waitDuration = 1.0 + _random.nextDouble() * 8.0; // 1~5초 대기
        _waitTimer = 0;
      }
    } else {
      _waitTimer += dt;
      if (_waitTimer >= _waitDuration) {
        _resetStar();
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // 크기 변경 시에도 y만 랜덤, x는 0~game.size.x
    double randomY = _random.nextDouble() * game.size.y;
    _start = Vector2(0, randomY);
    _end = Vector2(game.size.x, randomY);
  }
}
