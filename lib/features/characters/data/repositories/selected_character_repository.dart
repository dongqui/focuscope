import '../datasources/selected_character_datasource.dart';

import '../models/selected_character.dart';

class SelectedCharacterRepository {
  final SelectedCharacterDataSource dataSource;

  // 싱글톤 인스턴스를 저장할 정적 변수
  static SelectedCharacterRepository? _instance;

  // 외부에서 데이터 소스를 주입받는 생성자
  SelectedCharacterRepository._internal(this.dataSource);

  // 싱글톤 인스턴스를 반환하는 정적 getter
  static SelectedCharacterRepository get instance {
    if (_instance == null) {
      throw Exception(
          "FocusSessionRepository is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  // 초기화 메서드
  static void initialize(SelectedCharacterDataSource dataSource) {
    _instance ??= SelectedCharacterRepository._internal(dataSource);
  }

  // 캐릭터 선택
  Future<void> setSelectedCharacter(String characterName) async {
    await dataSource.setSelectedCharacter(characterName);
  }

  // 선택된 캐릭터 불러오기
  Future<SelectedCharacter?> getSelectedCharacter() async {
    return await dataSource.getSelectedCharacter();
  }

  // 앱 시작 시 선택된 캐릭터가 없으면 기본 캐릭터 설정
  Future<void> initSelectedCharacter(String name) async {
    final hasCharacter = await getSelectedCharacter();
    if (hasCharacter == null) {
      await dataSource.setSelectedCharacter(name);
    }
  }
}
