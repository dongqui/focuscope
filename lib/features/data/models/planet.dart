import 'package:isar/isar.dart';

part 'planet.g.dart';

final defaultPlanets = [
  Planet(id: 1, name: '', url: 'planets/planet_1.png', isPremium: false),
  Planet(id: 2, name: '', url: 'planets/planet_2.png', isPremium: false),
];

@Collection()
class Planet {
  Id id;

  late String name;
  late String url;
  late bool isPremium;

  Planet({
    required this.id,
    required this.name,
    required this.url,
    required this.isPremium,
  });

  factory Planet.fromJson(Map<String, dynamic> json) => Planet(
        id: json['id'],
        name: json['name'],
        url: json['url'],
        isPremium: json['isPremium'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'isPremium': isPremium,
      };
}
