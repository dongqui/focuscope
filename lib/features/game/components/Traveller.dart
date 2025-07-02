import 'package:flame/components.dart';

class Traveller extends SpriteAnimationComponent with HasGameReference {
  Traveller({required this.imagePath, required this.frames});
  String imagePath;
  List<int> frames;

  @override
  Future<void> onLoad() async {
    setCharacter(imagePath, frames);
  }

  Future<void> setCharacter(String newImagePath, List<int> newFrames) async {
    final spriteSheet = await game.images.load(newImagePath);
    final animationFrames = newFrames
        .map((index) => Sprite(
              spriteSheet,
              srcSize: Vector2(256, 256),
              srcPosition: Vector2(index * 256, 0),
            ))
        .toList();
    animation = SpriteAnimation.spriteList(
      animationFrames,
      stepTime: 0.2,
    );
  }
}
