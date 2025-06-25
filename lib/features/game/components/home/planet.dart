import 'package:flame/components.dart';

class Planet extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    final planetSpriteSheet = await game.images.load('planet.png');
    sprite = Sprite(planetSpriteSheet);
    size = Vector2(game.size.x, game.size.x);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(0, game.size.y - game.size.x / 2);
  }
}
