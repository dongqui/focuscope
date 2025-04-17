import 'package:isar/isar.dart';

part 'latest-activity-model.g.dart';

@Collection()
class LatestActivity {
  Id id = Isar.autoIncrement;
  final String name;
  final DateTime timestamp;
  bool hasDeleted = false;

  LatestActivity({
    required this.id,
    required this.name,
    required this.timestamp,
  });

  // JSON serialization/deserialization methods
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'timestamp': timestamp.toIso8601String(),
      };

  factory LatestActivity.fromJson(Map<String, dynamic> json) {
    return LatestActivity(
      id: json['id'],
      name: json['name'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
