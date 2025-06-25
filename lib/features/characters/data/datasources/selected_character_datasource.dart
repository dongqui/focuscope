import 'package:isar/isar.dart';
import '../models/selected_character.dart';

class SelectedCharacterDataSource {
  final Isar _isar;

  SelectedCharacterDataSource(this._isar);

  Future<void> setSelectedCharacter(String characterName) async {
    await _isar.writeTxn(() async {
      // 기존 선택 삭제
      await _isar.selectedCharacters.clear();
      // 새 선택 저장
      await _isar.selectedCharacters
          .put(SelectedCharacter(name: characterName));
    });
  }

  Future<SelectedCharacter?> getSelectedCharacter() async {
    return await _isar.selectedCharacters.where().findFirst();
  }
}
