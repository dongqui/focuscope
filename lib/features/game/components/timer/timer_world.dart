import 'package:flame/components.dart';
import 'space_map.dart';
import 'timer_traveller.dart';
import 'package:catodo/features/data/models/character.dart';

class TimerWorld extends World with HasGameReference {
  late final SpaceMap spaceMap;
  TimerTraveller? traveller;

  @override
  Future<void> onLoad() async {
    spaceMap = SpaceMap()..priority = 0;

    addAll([spaceMap]);
  }

  setTraveller(Character character) {
    if (traveller != null) {
      traveller?.setCharacter(character.travelSprite, character.travelframes);
    } else {
      traveller = TimerTraveller(
          imagePath: character.travelSprite, frames: character.travelframes)
        ..priority = 1;
      add(traveller!);
    }
  }

  pause() {
    spaceMap.pause();
  }

  resume() {
    spaceMap.resume();
  }
}
