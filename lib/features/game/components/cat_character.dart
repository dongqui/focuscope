import 'package:flame/components.dart';
import 'dart:math' as math;
import 'package:catodo/features/game/events/game_event_bus.dart';
import 'package:catodo/features/overlays/data/models/timer_state.dart';

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
    angle = math.pi / 10;

    // 이벤트 구독 설정
    GameEventBus().stream.listen(_handleEvent);
  }

  void _handleEvent(GameEvent event) {
    if (event is TimerStateChangedEvent) {
      _updateAnimation(event.state);
    }
  }

  void _updateAnimation(TimerState state) {
    switch (state.status) {
      case TimerStatus.running:
        if (!_isDancing) {
          startDancing();
        }
        break;
      case TimerStatus.paused:
      case TimerStatus.completed:
      case TimerStatus.idle:
        if (_isDancing) {
          stopDancing();
        }
        break;
    }
  }

  void startDancing() {
    animation = _danceAnimation;
    _isDancing = true;
  }

  void stopDancing() {
    animation = null;
    _isDancing = false;
  }
}
