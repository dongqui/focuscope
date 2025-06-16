import 'package:flame/components.dart';
import 'space_map.dart';
import 'cat_character.dart';
import 'cat_character2.dart';
import 'cat_character3.dart';

class GameWorld extends World with HasGameReference {
  late final SpaceMap spaceMap;
  late final CatCharacter cat;
  late final CatCharacter2 cat2;
  late final CatCharacter3 cat3;
  @override
  Future<void> onLoad() async {
    // 맵 생성 및 추가
    spaceMap = SpaceMap();
    await add(spaceMap);

    // 고양이 생성 및 추가
    cat = CatCharacter();
    // 화면 중앙에 배치 (카메라 뷰포트 기준)
    cat.position = Vector2(50, 50); // 화면 중앙 좌표로 설정

    await add(cat);

    cat2 = CatCharacter2();

    await add(cat2);

    cat3 = CatCharacter3();
    cat3.position = Vector2(100, 100);
    await add(cat3);
  }

  // 고양이 이동 메서드
  void moveCat(Vector2 target) {
    cat.position = target;
  }
}
