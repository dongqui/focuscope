import 'package:isar/isar.dart';
import '../models/resource_version.dart';

class ResourceVersionDataSource {
  final Isar _isar;

  ResourceVersionDataSource(this._isar);

  // 리소스 타입별 버전 정보 조회
  Future<ResourceVersion?> getResourceVersion(String resourceType) async {
    return await _isar.resourceVersions
        .filter()
        .resourceTypeEqualTo(resourceType)
        .findFirst();
  }

  // 모든 리소스 버전 정보 조회
  Future<List<ResourceVersion>> getAllResourceVersions() async {
    return await _isar.resourceVersions.where().findAll();
  }

  // 리소스 버전 정보 저장 또는 업데이트
  Future<void> saveResourceVersion(ResourceVersion version) async {
    await _isar.writeTxn(() async {
      await _isar.resourceVersions.put(version);
    });
  }

  // 리소스 버전 정보 삭제
  Future<void> deleteResourceVersion(String resourceType) async {
    await _isar.writeTxn(() async {
      await _isar.resourceVersions
          .filter()
          .resourceTypeEqualTo(resourceType)
          .deleteAll();
    });
  }

  // 다운로드 상태 업데이트
  Future<void> updateDownloadStatus(String resourceType, bool isDownloaded) async {
    final version = await getResourceVersion(resourceType);
    if (version != null) {
      version.isDownloaded = isDownloaded;
      await saveResourceVersion(version);
    }
  }
}
