import 'package:catodo/core/db.dart';
import 'package:catodo/features/characters/data/repositories/character_repository.dart';
import 'package:catodo/features/characters/data/repositories/selected_character_repository.dart';
import 'package:catodo/features/characters/data/models/character.dart';

Future<void> init() async {
  await DatabaseService.instance.setUpDB();
  await CharacterRepository.instance.initializeDefaultCharacters();
  await SelectedCharacterRepository.instance
      .initSelectedCharacter(defaultCharacters[0].name);
}
