import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class VillageMap extends PositionComponent {
  late final TiledComponent _tiledMap;

  @override
  Future<void> onLoad() async {
    // Tiled 맵 로드
    _tiledMap = await TiledComponent.load(
      'cozy-village.tmx',
      Vector2.all(32),
    );

    // 맵 크기 설정 (50x50 타일)
    size = Vector2(50 * 32, 50 * 32);

    // 맵을 화면 중앙에 위치시키기 위해 오프셋 설정
    position = -size / 2;

    // 맵 추가
    add(_tiledMap);
  }
}
