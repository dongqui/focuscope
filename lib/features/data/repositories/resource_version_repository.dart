import '../datasources/resource_version_datasource.dart';
import '../models/resource_version.dart';
import '../services/resource_update_service.dart';
import 'package:catodo/features/data/models/resource.dart';

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

  Future<void> addDefaultResourceVersionIfEmpty() async {
    await dataSource.addDefaultResourceVersionIfEmpty();
  }

  // 리소스 버전 정보 저장 또는 업데이트
  Future<void> saveResourceVersion(version, checkedAt) async {
    await dataSource.saveResourceVersion(ResourceVersion(
      version: version,
      checkedAt: checkedAt,
    ));
  }

  /// 디바이스 DB에서 현재 리소스 버전을 가져옵니다
  Future<ResourceVersion?> getCurrentResourceVersion() async {
    return await dataSource.getCurrentResourceVersion();
  }

  /// 서버에서 최신 리소스 버전을 가져옵니다
  Future<int?> getServerResourceVersion() async {
    try {
      final res =
          await ResourceUpdateService.instance.fetchServerResourceInfo();

      return res?.version;
    } catch (e) {
      return null;
    }
  }

  Future<VersionWithResources?> getResourcesBetweenVersions(
      currentVersion) async {
    final res = await ResourceUpdateService.instance
        .fetchResourcesBetweenVersions(currentVersion);

    return res;
  }

  Future<void> downloadResources(List<Resource> resources) async {
    await Future.wait(resources.map((resource) async {
      if (resource.resourceType == "planet") {
        return downloadPlanetImage(resource.url, resource.name);
      } else if (resource.resourceType == "character") {
        return downloadCharacterImage(
            resource.travelSprite, resource.idleSprite, resource.name);
      }
    }));
  }

  Future<void> downloadPlanetImage(String? url, String name) async {
    if (url != null) {
      await ResourceUpdateService.instance.downloadImage(url, 'planets/$name');
    }
  }

  Future<void> downloadCharacterImage(
      String? travelSprite, String? idleSprite, String name) async {
    if (travelSprite != null && idleSprite != null) {
      Future.wait([
        ResourceUpdateService.instance
            .downloadImage(travelSprite, 'characters/${name}_travel'),
        ResourceUpdateService.instance
            .downloadImage(idleSprite, 'characters/${name}_idle'),
      ]);
    }
  }
}
