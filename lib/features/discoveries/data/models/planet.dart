import 'package:isar/isar.dart';

part 'planet.g.dart';

@Collection()
class Planet {
  Id id;

  late String name;
  late String image;

  Planet({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Planet.fromJson(Map<String, dynamic> json) => Planet(
        id: json['id'],
        name: json['name'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };
}
