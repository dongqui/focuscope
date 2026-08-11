class SelectedCharacter {
  /// DocumentStore가 부여하는 자동 증가 id. 저장 전에는 null이다.
  int? id;

  late String name;

  SelectedCharacter({this.id, required this.name});

  factory SelectedCharacter.fromJson(Map<String, dynamic> json) =>
      SelectedCharacter(
        id: json['id'] as int?,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
