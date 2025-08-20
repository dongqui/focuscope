import '../datasources/resource_version_datasource.dart';
import '../models/resource_version.dart';

class ResourceVersionRepository {
  final ResourceVersionDataSource dataSource;

  // 싱글톤 인스턴스를 저장할 정적 변수
  static ResourceVersionRepository? _instance;

  // 외부에서 데이터 소스를 주입받는 생성자
  ResourceVersionRepository._internal(this.dataSource);

  // 싱글톤 인스턴스를 반환하는 정적 getter
  static ResourceVersionRepository get instance {
    if (_instance == null) {
      throw Exception(
          "ResourceVersionRepository is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  // 초기화 메서드
  static void initialize(ResourceVersionDataSource dataSource) {
    _instance ??= ResourceVersionRepository._internal(dataSource);
  }

  // 리소스 타입별 버전 정보 조회
  Future<ResourceVersion?> getResourceVersion(String resourceType) async {
    return await dataSource.getResourceVersion(resourceType);
  }

  // 모든 리소스 버전 정보 조회
  Future<List<ResourceVersion>> getAllResourceVersions() async {
    return await dataSource.getAllResourceVersions();
  }

  // 리소스 버전 정보 저장 또는 업데이트
  Future<void> saveResourceVersion(ResourceVersion version) async {
    await dataSource.saveResourceVersion(version);
  }

  // 리소스 버전 정보 삭제
  Future<void> deleteResourceVersion(String resourceType) async {
    await dataSource.deleteResourceVersion(resourceType);
  }

  // 다운로드 상태 업데이트
  Future<void> updateDownloadStatus(
      String resourceType, bool isDownloaded) async {
    await dataSource.updateDownloadStatus(resourceType, isDownloaded);
  }
}
