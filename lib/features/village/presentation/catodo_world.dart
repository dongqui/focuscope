import 'package:flame/components.dart';
import 'components/village_map.dart';
import 'components/cat_character.dart';

class CatodoWorld extends World {
  late final VillageMap villageMap;
  late final CatCharacter cat;

  @override
  Future<void> onLoad() async {
    // 맵 생성 및 추가
    villageMap = VillageMap();
    // add(villageMap);

    // 고양이 생성 및 추가
    cat = CatCharacter();
    // cat.position = Vector2(-villageMap.size.x / 4, -villageMap.size.y / 4);
    add(cat);
  }
}
