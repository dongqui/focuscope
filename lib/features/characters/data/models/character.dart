import 'package:isar/isar.dart';

part 'character.g.dart';

final List<Character> defaultCharacters = [
  Character(name: 'astronaut'),
  Character(name: 'dog_white'),
];

@Collection()
class Character {
  Id id = Isar.autoIncrement;
  late String name;
  // 필요하다면 이미지, 설명 등 추가 가능

  Character({
    required this.name,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
