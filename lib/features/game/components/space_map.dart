import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class SpaceMap extends Component {
  late final ParallaxComponent _spaceBackground;

  @override
  Future<void> onLoad() async {
    // 우주 배경 이미지 로드 및 parallax 설정
    _spaceBackground = await ParallaxComponent.load([
      ParallaxImageData('universe.webp'),
      ParallaxImageData('universe.webp'),
      ParallaxImageData('universe.webp'),
    ],
        baseVelocity: Vector2(40, 0), // 가로로 천천히 이동
        size: Vector2(2056, 2056));

    // 컴포넌트에 추가
    add(_spaceBackground);
  }

  void setBaseVelocity(Vector2 velocity) {
    _spaceBackground.parallax?.baseVelocity = velocity;
  }
}
