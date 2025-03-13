import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'cat_character.dart';

class VillageMap extends PositionComponent {
  late final TiledComponent _tiledMap;
  late final CatCharacter _cat;

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

    // 고양이 캐릭터 생성 및 추가
    _cat = CatCharacter();
    // 고양이의 초기 위치를 맵의 왼쪽 상단 근처로 설정
    _cat.position = Vector2(-size.x / 4, -size.y / 4);

    // 컴포넌트 추가
    add(_tiledMap);
    add(_cat);
  }

  void moveCat(Vector2 target) {
    _cat.moveTo(target);
  }
}
