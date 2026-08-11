class LatestActivity {
  /// DocumentStore가 부여하는 자동 증가 id. 저장 전에는 null이다.
  int? id;

  final String name;
  final DateTime timestamp;
  bool hasDeleted;

  LatestActivity({
    this.id,
    required this.name,
    required this.timestamp,
    this.hasDeleted = false,
  });

  factory LatestActivity.fromJson(Map<String, dynamic> json) => LatestActivity(
        id: json['id'] as int?,
        name: json['name'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        hasDeleted: json['hasDeleted'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'timestamp': timestamp.toIso8601String(),
        'hasDeleted': hasDeleted,
      };
}
