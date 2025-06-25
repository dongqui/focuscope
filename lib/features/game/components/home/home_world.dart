import 'package:flame/components.dart';
import 'planet.dart';
import 'stars.dart';
import 'traveller.dart';

class HomeWorld extends World with HasGameReference {
  late final Planet planet;
  late final Stars stars;
  late final Traveller traveller;
  @override
  Future<void> onLoad() async {
    planet = Planet();
    stars = Stars();
    traveller = Traveller();

    // planet.position = Vector2(game.size.x / 2, game.size.y / 2);
    await addAll([planet, stars, traveller]);
  }
}
