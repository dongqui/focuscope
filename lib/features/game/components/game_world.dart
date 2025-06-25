import 'package:flame/components.dart';
import 'space_map.dart';

import 'travller.dart';

class GameWorld extends World with HasGameReference {
  late final SpaceMap spaceMap;
  late final Travller travller;

  @override
  Future<void> onLoad() async {
    spaceMap = SpaceMap();
    travller = Travller();

    addAll([spaceMap, travller]);
  }

  pause() {
    spaceMap.pause();

  }

  resume() {
    spaceMap.resume();
  }
}
