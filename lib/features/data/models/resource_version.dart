final defaultResourceVersion = ResourceVersion(
  version: 1,
  checkedAt: DateTime.now(),
);

class ResourceVersion {
  /// DocumentStore가 부여하는 자동 증가 id. 저장 전에는 null이다.
  int? id;

  late int version;
  late DateTime checkedAt;

  ResourceVersion({
    this.id,
    required this.version,
    required this.checkedAt,
  });

  factory ResourceVersion.fromJson(Map<String, dynamic> json) =>
      ResourceVersion(
        id: json['id'] as int?,
        version: json['version'] as int,
        checkedAt: DateTime.parse(json['checkedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'version': version,
        'checkedAt': checkedAt.toIso8601String(),
      };
}
