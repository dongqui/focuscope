import 'package:isar/isar.dart';
import '../models/resource_version.dart';

class ResourceVersionDataSource {
  final Isar _isar;

  ResourceVersionDataSource(this._isar);

  // 리소스 버전 정보 저장 또는 업데이트
  Future<void> saveResourceVersion(ResourceVersion version) async {
    await _isar.writeTxn(() async {
      await _isar.resourceVersions.put(version);
    });
  }

  Future<void> addDefaultResourceVersionIfEmpty() async {
    final count = await _isar.resourceVersions.count();
    if (count == 0) {
      await _isar.writeTxn(() async {
        await _isar.resourceVersions.put(defaultResourceVersion);
      });
    }
  }

  /// 디바이스 DB에서 현재 리소스 버전을 가져옵니다
  Future<ResourceVersion?> getCurrentResourceVersion() async {
    try {
      // 가장 최근에 업데이트된 버전을 가져옵니다
      final versions = await _isar.resourceVersions.where().findAll();

      return versions.isNotEmpty ? versions.first : null;
    } catch (e) {
      return null;
    }
  }
}
