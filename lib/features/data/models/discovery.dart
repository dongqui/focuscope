import 'package:isar/isar.dart';

part 'discovery.g.dart';

@Collection()
class Discovery {
  Id id = Isar.autoIncrement;
  List<int> sessionIds;
  int planetId;
  bool isFinished;

  Discovery({
    required this.id,
    required this.sessionIds,
    required this.planetId,
    required this.isFinished,
  });

  factory Discovery.fromJson(Map<String, dynamic> json) => Discovery(
        id: json['id'],
        sessionIds: List<int>.from(json['sessionIds'], growable: true),
        planetId: json['planetId'],
        isFinished: json['isFinished'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionIds': sessionIds,
        'planetId': planetId,
        'isFinished': isFinished,
      };
}
