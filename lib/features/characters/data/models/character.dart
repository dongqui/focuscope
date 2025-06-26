import 'package:isar/isar.dart';

part 'character.g.dart';

final List<Character> defaultCharacters = [
  Character(
      name: 'astronaut',
      travelframes: [0, 1, 2, 3, 2, 1],
      travelSprite: 'astronaut_travel.png',
      idleSprite: 'astronaut_idle.png',
      idleFrames: [0]),
  Character(
      name: 'dog_white',
      travelframes: [0, 1, 2, 3],
      travelSprite: 'dog_white_travel.png',
      idleSprite: 'dog_white_idle.png',
      idleFrames: [0]),
];

@Collection()
class Character {
  Id id = Isar.autoIncrement;
  late String name;
  late List<int> travelframes;
  late String travelSprite;
  late String idleSprite;
  late List<int> idleFrames;

  Character({
    required this.name,
    required this.travelframes,
    required this.travelSprite,
    required this.idleSprite,
    required this.idleFrames,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        name: json['name'],
        travelframes: json['travelframes'],
        travelSprite: json['travelSprite'],
        idleSprite: json['idleSprite'],
        idleFrames: json['idleFrames'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'travelframes': travelframes,
        'travelSprite': travelSprite,
        'idleSprite': idleSprite,
        'idleFrames': idleFrames,
      };
}
