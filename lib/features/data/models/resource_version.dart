import 'package:isar/isar.dart';

part 'resource_version.g.dart';

final defaultResourceVersion = ResourceVersion(
  version: 1,
  checkedAt: DateTime.now(),
);

@Collection()
class ResourceVersion {
  Id id = Isar.autoIncrement;

  late int version;
  late DateTime checkedAt;

  ResourceVersion({
    required this.version,
    required this.checkedAt,
  });

  factory ResourceVersion.fromJson(Map<String, dynamic> json) =>
      ResourceVersion(
        version: json['version'],
        checkedAt: DateTime.parse(json['checkedAt']),
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'version': version, 'checkedAt': checkedAt.toIso8601String()};
}
