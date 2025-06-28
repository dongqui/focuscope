import 'package:flame/components.dart';
import 'space_map.dart';
import 'timer_travller.dart';
import 'package:catodo/features/data/models/character.dart';

class TimerWorld extends World with HasGameReference {
  late final SpaceMap spaceMap;
  TimerTraveller? travller;

  @override
  Future<void> onLoad() async {
    spaceMap = SpaceMap();

    addAll([spaceMap]);
  }

  setTraveller(Character character) {
    if (travller != null) {
      remove(travller!);
    }

    travller = TimerTraveller(
        imagePath: character.travelSprite, frames: character.travelframes);
    add(travller!);
  }

  pause() {
    spaceMap.pause();
  }

  resume() {
    spaceMap.resume();
  }
}
