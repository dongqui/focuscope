import 'package:catodo/core/observer.dart';

import 'package:catodo/features/data/models/character.dart';
import 'package:catodo/features/data/repositories/selected_character_repository.dart';
import 'package:catodo/features/data/repositories/character_repository.dart';

class CharacterState {
  final Character? selectedCharacter;
  final List<Character> characterList;

  CharacterState({
    required this.selectedCharacter,
    required this.characterList,
  });

  CharacterState copyWith({
    Character? selectedCharacter,
    List<Character>? characterList,
  }) {
    return CharacterState(
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      characterList: characterList ?? this.characterList,
    );
  }
}

class CharacterManager extends Observer<CharacterState> {
  static final CharacterManager _instance = CharacterManager._internal();
  static CharacterManager get instance => _instance;

  CharacterState _state;

  CharacterManager._internal()
      : _state = CharacterState(
          selectedCharacter: null,
          characterList: [],
        );

  CharacterState get state => _state;

  Future<void> getCharacterList() async {
    final characters = state.characterList.isEmpty
        ? await CharacterRepository.instance.getCharacters()
        : state.characterList;

    _updateState(_state.copyWith(
      characterList: characters,
    ));
  }

  Future<void> initSelectedCharacter() async {
    if (_state.selectedCharacter == null) {
      final selectedCharacterMeta =
          await SelectedCharacterRepository.instance.getSelectedCharacter();
      final selectedCharacter = await CharacterRepository.instance
          .getCharacter(selectedCharacterMeta?.name ?? '');

      _updateState(_state.copyWith(
        selectedCharacter: selectedCharacter,
      ));
    }
  }

  Future<void> updateCharacter(Character character) async {
    await SelectedCharacterRepository.instance
        .setSelectedCharacter(character.name);
    _updateState(_state.copyWith(
      selectedCharacter: character,
    ));
  }

  void _updateState(CharacterState state) {
    _state = state;
    notifyListeners(state);
  }
}
