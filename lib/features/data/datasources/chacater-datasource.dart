import 'package:isar/isar.dart';
import 'package:catodo/features/data/models/character.dart';

class CharacterDataSource {
  final Isar _isar;

  CharacterDataSource(this._isar);

  // 기본 캐릭터 데이터


  // DB에 기본 캐릭터 데이터 삽입
  Future<void> insertDefaultCharacters() async {
    final characters = await _isar.characters.where().findAll();
    if (characters.isEmpty) {
      await _isar.writeTxn(() async {
        await _isar.characters.putAll(defaultCharacters);
      });
    }
  }

  // 캐릭터 리스트 반환, 비어있으면 기본 데이터 삽입
  Future<List<Character>> getCharacters() async {
    return await _isar.characters.where().findAll();
  }

  // id로 캐릭터 정보 반환
  Future<Character?> getCharacter(String characterName) async {
    return await _isar.characters
        .filter()
        .nameEqualTo(characterName)
        .findFirst();
  }
}
