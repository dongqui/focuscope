import 'package:catodo/core/storage/document_store.dart';

import '../models/selected_character.dart';

class SelectedCharacterDataSource {
  final DocumentStore<SelectedCharacter> _store;

  SelectedCharacterDataSource(this._store);

  Future<void> setSelectedCharacter(String characterName) async {
    // 기존 선택 삭제 후 새 선택 저장
    await _store.clear();
    await _store.add(SelectedCharacter(name: characterName));
  }

  Future<SelectedCharacter?> getSelectedCharacter() async {
    final selected = _store.query();
    return selected.isEmpty ? null : selected.first;
  }
}
