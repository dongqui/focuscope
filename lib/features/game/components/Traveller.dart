import 'package:flame/components.dart';

class Traveller extends SpriteAnimationComponent with HasGameReference {
  Traveller({required this.imagePath, required this.frames});
  final String imagePath;
  final List<int> frames;

  @override
  Future<void> onLoad() async {
    final dogSpriteSheet = await game.images.load(imagePath);
    final animationFrames = frames
        .map((index) => Sprite(
              dogSpriteSheet,
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
