import '../traveller.dart';
import 'package:flame/components.dart';

class HomeTraveller extends Traveller {
  HomeTraveller({required super.imagePath, required super.frames});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2(128, 128);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position =
        Vector2((game.size.x / 2 - 64), game.size.y - game.size.x / 2 - 100);
  }
}
