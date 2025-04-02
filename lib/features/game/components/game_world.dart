import 'package:flame/components.dart';
import 'village_map.dart';
import 'cat_character.dart';

class GameWorld extends World {
  late final VillageMap villageMap;
  late final CatCharacter cat;

  @override
  Future<void> onLoad() async {
    // 맵 생성 및 추가
    villageMap = VillageMap();
    await add(villageMap);

    // 고양이 생성 및 추가
    cat = CatCharacter();
    cat.position = Vector2.zero(); // 고양이를 화면 중앙에 배치
    await add(cat);
  }

  // 고양이 이동 메서드
  void moveCat(Vector2 target) {
    cat.position = target;
  }
}
