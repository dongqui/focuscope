import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'dart:ui';

import 'package:flame/game.dart';

class Stars extends FlameGame {
  static const String description = '''
    Shows how to create a parallax with different velocity deltas on each layer.
  ''';

  final _layersMeta = {
    'star_1.png': 0.5,
    'star_2.png': 0.75,
    'star_2_5.png': 0.85,
    'star_3.png': 1.0,
  };

  @override
  Future<void> onLoad() async {
    final layers = _layersMeta.entries.map(
      (e) => loadParallaxLayer(
        ParallaxImageData(e.key),
        velocityMultiplier: Vector2(e.value, 1.0),
        filterQuality: FilterQuality.none,
      ),
    );
    final parallax = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(20, 0),
      ),
    );
    add(parallax);
  }
}
