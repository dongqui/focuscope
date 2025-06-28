import 'package:isar/isar.dart';

part 'selected_character.g.dart';

@Collection()
class SelectedCharacter {
  Id id = Isar.autoIncrement;
  late String name;

  SelectedCharacter({required this.name});

  factory SelectedCharacter.fromJson(Map<String, dynamic> json) =>
      SelectedCharacter(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
