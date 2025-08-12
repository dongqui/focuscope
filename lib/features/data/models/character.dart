import 'package:isar/isar.dart';

part 'character.g.dart';

final List<Character> defaultCharacters = [
  Character(
      id: 1,
      name: 'astronaut',
      travelframes: [0],
      travelSprite: 'characters/astronaut_travel.png',
      idleSprite: 'characters/astronaut_idle.png',
      idleFrames: [0],
      isPremium: false),
  Character(
      id: 2,
      name: 'dog_white',
      travelframes: [0, 1, 2, 3],
      travelSprite: 'characters/dog_white_travel.png',
      idleSprite: 'characters/dog_white_idle.png',
      idleFrames: [0],
      isPremium: false),
];

@Collection()
class Character {
  @Index(unique: true)
  Id id;
  late String name;
  late List<int> travelframes;
  late String travelSprite;
  late String idleSprite;
  late List<int> idleFrames;
  late bool isPremium;
  Character({
    required this.id,
    required this.name,
    required this.travelframes,
    required this.travelSprite,
    required this.idleSprite,
    required this.idleFrames,
    required this.isPremium,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json['id'],
        name: json['name'],
        travelframes: json['travelframes'],
        travelSprite: json['travelSprite'],
        idleSprite: json['idleSprite'],
        idleFrames: json['idleFrames'],
        isPremium: json['isPremium'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'travelframes': travelframes,
        'travelSprite': travelSprite,
        'idleSprite': idleSprite,
        'idleFrames': idleFrames,
        'isPremium': isPremium,
      };
}
