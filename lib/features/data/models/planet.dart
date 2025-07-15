import 'package:isar/isar.dart';

part 'planet.g.dart';

final defaultPlanets = [
  Planet(id: 1, name: '', sprite: 'planets/planet_1.png', frames: [0]),
  Planet(id: 2, name: '', sprite: 'planets/planet_2.png', frames: [0]),
];

@Collection()
class Planet {
  Id id;

  late String name;
  late String sprite;
  late List<int> frames;

  Planet({
    required this.id,
    required this.name,
    required this.sprite,
    required this.frames,
  });

  factory Planet.fromJson(Map<String, dynamic> json) => Planet(
        id: json['id'],
        name: json['name'],
        sprite: json['sprite'],
        frames: json['frames'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sprite': sprite,
        'frames': frames,
      };
}
