import 'package:catodo/core/storage/document_store.dart';
import 'package:catodo/features/data/models/character.dart';

class CharacterDataSource {
  final DocumentStore<Character> _store;

  CharacterDataSource(this._store);

  // DB에 기본 캐릭터 데이터 삽입
  Future<void> insertDefaultCharacters() async {
    if (_store.count > 0) return;
    // 시드 상수를 저장소와 공유하지 않도록 복사해서 넣는다.
    await _store.addAll(
      defaultCharacters.map((c) => Character.fromJson(c.toJson())),
    );
  }

  // 캐릭터 리스트 반환
  Future<List<Character>> getCharacters() async {
    return _store.query();
  }

  // 이름으로 캐릭터 정보 반환
  Future<Character?> getCharacter(String characterName) async {
    final matches = _store.query(where: (c) => c.name == characterName);
    return matches.isEmpty ? null : matches.first;
  }

  // 캐릭터 업데이트 또는 추가
  Future<void> updateCharacter(Character character) async {
    await _store.put(character.id, character);
  }
}
