import 'package:catodo/core/observer.dart';
import 'package:catodo/features/data/models/character.dart';
import 'package:catodo/features/data/models/planet.dart';
import 'package:catodo/features/data/repositories/character_repository.dart';
import 'package:catodo/features/data/repositories/planet_repository.dart';
import 'package:catodo/features/data/repositories/resource_version_repository.dart';

enum ResourceVersionStatus {
  idle,
  loading,
  done,
  failed,
}

class ResourceVersionState {
  final bool shouldUpdate;
  final ResourceVersionStatus status;
  final DateTime? checkedAt;
  final int? version;

  ResourceVersionState({
    required this.shouldUpdate,
    required this.status,
    this.checkedAt,
    this.version,
  });

  ResourceVersionState copyWith({
    bool? shouldUpdate,
    ResourceVersionStatus? status,
    DateTime? checkedAt,
    int? version,
  }) {
    return ResourceVersionState(
      shouldUpdate: shouldUpdate ?? this.shouldUpdate,
      status: status ?? this.status,
      checkedAt: checkedAt ?? this.checkedAt,
      version: version ?? this.version,
    );
  }
}

class ResourceVersionManager extends Observer<ResourceVersionState> {
  static final ResourceVersionManager _instance =
      ResourceVersionManager._internal();
  static ResourceVersionManager get instance => _instance;

  ResourceVersionState _state;

  ResourceVersionManager._internal()
      : _state = ResourceVersionState(
          shouldUpdate: false,
          status: ResourceVersionStatus.idle,
          checkedAt: null,
          version: null,
        );

  ResourceVersionState get state => _state;

  Future<void> initVersion() async {
    final version =
        await ResourceVersionRepository.instance.getCurrentResourceVersion();
    _updateState(_state.copyWith(
      version: version?.version,
      checkedAt: version?.checkedAt,
    ));
  }

  /// 버전 비교를 수행합니다
  Future<bool> checkVersionUpdate() async {
    _updateState(_state.copyWith(
      status: ResourceVersionStatus.loading,
    ));

    // 서버에서 최신 버전 가져오기
    final serverVersion =
        await ResourceVersionRepository.instance.getServerResourceVersion();

    final needsUpdate = serverVersion! > _state.version!;

    return needsUpdate;
  }

  Future<void> updateResources() async {
    print('updateResources');
    final resources = await ResourceVersionRepository.instance
        .getResourcesBetweenVersions(_state.version!);
    print(resources);
    if (resources != null) {
      await ResourceVersionRepository.instance
          .downloadResources(resources.resources);

      await ResourceVersionRepository.instance.saveResourceVersion(
        resources.version,
        DateTime.now(),
      );

      await Future.wait(resources.resources.map((resource) {
        if (resource.resourceType == "character") {
          return CharacterRepository.instance.updateCharacter(Character(
            id: int.parse(resource.id),
            name: resource.name,
            travelframes: resource.travelframes ?? [],
            travelSprite: resource.travelSprite ?? '',
            idleSprite: resource.idleSprite ?? '',
            idleFrames: resource.idleFrames ?? [],
            isPremium: resource.isPremium ?? false,
          ));
        } else if (resource.resourceType == "planet") {
          return PlanetRepository.instance.updatePlanet(Planet(
            id: int.parse(resource.id),
            name: resource.name,
            url: resource.url ?? '',
            isPremium: resource.isPremium ?? false,
          ));
        }
        return Future.value();
      }));
    }
  }

  void _updateState(ResourceVersionState state) {
    _state = state;
    notifyListeners(state);
  }
}
