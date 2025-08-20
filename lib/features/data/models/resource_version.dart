import 'package:isar/isar.dart';

part 'resource_version.g.dart';

@Collection()
class ResourceVersion {
  Id id = Isar.autoIncrement;

  late String resourceType; // 'character', 'planet'
  late String version;
  late DateTime lastUpdated;
  late bool isDownloaded;

  ResourceVersion({
    required this.resourceType,
    required this.version,
    required this.lastUpdated,
    this.isDownloaded = false,
  });

  factory ResourceVersion.fromJson(Map<String, dynamic> json) =>
      ResourceVersion(
        resourceType: json['resourceType'],
        version: json['version'],
        lastUpdated: DateTime.parse(json['lastUpdated']),
        isDownloaded: json['isDownloaded'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'resourceType': resourceType,
        'version': version,
        'lastUpdated': lastUpdated.toIso8601String(),
        'isDownloaded': isDownloaded,
      };
}
