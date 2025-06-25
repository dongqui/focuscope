import 'package:flame/components.dart';

class Traveller extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    final planetSpriteSheet = await game.images.load('traveller.png');
    sprite = Sprite(planetSpriteSheet);
    size = Vector2(128, 128);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position =
        Vector2(game.size.x / 2 - 64, game.size.y - game.size.x / 2 - 96);
  }
}
