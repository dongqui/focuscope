import 'package:flame/components.dart';
import 'planet.dart';
import 'stars.dart';
import 'home_traveller.dart';
import 'package:catodo/features/data/models/character.dart';
import 'flowstar.dart';

class HomeWorld extends World with HasGameReference {
  late final Planet planet;
  late final Stars stars;
  late final FlowStar flowstar_right;
  late final FlowStar flowstar_left;
  HomeTraveller? traveller;

  @override
  Future<void> onLoad() async {
    planet = Planet()..priority = 2;
    stars = Stars()..priority = 1;
    flowstar_right = FlowStar(FlowStarDirection.right)
      ..position = Vector2(game.size.x / 2, game.size.y / 2)
      ..priority = 0;
    flowstar_left = FlowStar(FlowStarDirection.left)
      ..position = Vector2(game.size.x / 2, game.size.y / 2)
      ..priority = 0;

    await addAll([planet, stars, flowstar_right, flowstar_left]);
  }

  setTraveller(Character character) {
    if (traveller != null) {
      traveller?.setCharacter(character.idleSprite, character.idleFrames);
    } else {
      traveller = HomeTraveller(
          imagePath: character.idleSprite, frames: character.idleFrames)
        ..priority = 2;

      add(traveller!);
    }
  }
}
