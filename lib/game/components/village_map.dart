import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class VillageMap extends PositionComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Tiled로 만든 맵 로드
    final tiledMap = await TiledComponent.load(
      'cozy-village.tmx',
      Vector2.all(32),
    );

    // 맵의 크기 설정 (타일 크기 * 타일 개수)
    size = Vector2(50 * 32, 50 * 32); // 50x50 타일 맵
    position = -size / 2; // 맵을 중앙에 위치시킴

    add(tiledMap);
  }
}
