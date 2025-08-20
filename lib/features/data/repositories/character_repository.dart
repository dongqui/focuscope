import '../datasources/chacater-datasource.dart';
import '../models/character.dart';

class CharacterRepository {
  final CharacterDataSource dataSource;

  // 싱글톤 인스턴스를 저장할 정적 변수
  static CharacterRepository? _instance;

  // 외부에서 데이터 소스를 주입받는 생성자
  CharacterRepository._internal(this.dataSource);

  // 싱글톤 인스턴스를 반환하는 정적 getter
  static CharacterRepository get instance {
    if (_instance == null) {
      throw Exception(
          "FocusSessionRepository is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  // 초기화 메서드
  static void initialize(CharacterDataSource dataSource) {
    _instance ??= CharacterRepository._internal(dataSource);
  }

  // 캐릭터 리스트 반환
  Future<List<Character>> getCharacters() async {
    return await dataSource.getCharacters();
  }

  // id로 캐릭터 정보 반환
  Future<Character?> getCharacter(String characterName) async {
    return await dataSource.getCharacter(characterName);
  }

  // 앱 실행 시 기본 캐릭터 데이터를 DB에 넣는 초기화 메서드
  Future<void> initializeDefaultCharacters() async {
    await dataSource.insertDefaultCharacters();
  }

  // 캐릭터 업데이트 또는 추가
  Future<void> updateCharacter(Character character) async {
    await dataSource.updateCharacter(character);
  }
}
