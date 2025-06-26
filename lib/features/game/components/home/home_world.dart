import 'package:flame/components.dart';
import 'planet.dart';
import 'stars.dart';
import 'home_traveller.dart';
import 'package:catodo/features/characters/data/models/character.dart';

class HomeWorld extends World with HasGameReference {
  late final Planet planet;
  late final Stars stars;
  HomeTraveller? traveller;

  @override
  Future<void> onLoad() async {
    planet = Planet();
    stars = Stars();

    // planet.position = Vector2(game.size.x / 2, game.size.y / 2);
    await addAll([planet, stars]);
  }

  setTraveller(Character character) {
    if (traveller != null) {
      remove(traveller!);
    }

    traveller = HomeTraveller(
        imagePath: character.idleSprite, frames: character.idleFrames);

    add(traveller!);
  }
}
