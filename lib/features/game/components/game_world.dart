import 'package:flame/components.dart';
import 'village_map.dart';
import 'cat_character.dart';

class GameWorld extends World with HasGameRef {
  late final VillageMap villageMap;
  late final CatCharacter cat;

  @override
  Future<void> onLoad() async {
    // 맵 생성 및 추가
    villageMap = VillageMap();
    await add(villageMap);

    // 고양이 생성 및 추가
    cat = CatCharacter();
    // 화면 중앙에 배치 (카메라 뷰포트 기준)
    cat.position = Vector2(100, 100); // 화면 중앙 좌표로 설정
    cat.size = Vector2.all(64); // 크기를 2배로 키움
    await add(cat);
  }

  // 고양이 이동 메서드
  void moveCat(Vector2 target) {
    cat.position = target;
  }
}
