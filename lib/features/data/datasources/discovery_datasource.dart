import 'package:isar/isar.dart';
import '../models/discovery.dart';
import '../models/planet.dart';

class DiscoveryDataSource {
  final Isar _isar;

  DiscoveryDataSource(this._isar);

  // isFinished가 false인 Discovery를 불러오고, 없으면 새로 생성
  Future<Discovery> getOrCreateActiveDiscovery() async {
    // 1. isFinished == false인 Discovery 찾기
    Discovery? discovery =
        await _isar.discoverys.filter().isFinishedEqualTo(false).findFirst();
    if (discovery != null) {
      return discovery;
    }
    // 2. planetId 후보군 구하기
    final planets = await _isar.planets.where().findAll();
    final usedPlanetIds = (await _isar.discoverys.where().findAll())
        .map((d) => d.planetId)
        .toSet();
    int? newPlanetId = planets.map((p) => p.id).firstWhere(
          (id) => !usedPlanetIds.contains(id),
          orElse: () => 1025,
        );
    // 3. 새 Discovery 생성
    final newDiscovery = Discovery(
      id: Isar.autoIncrement,
      sessionIds: [],
      planetId: newPlanetId,
      isFinished: false,
    );
    await _isar.writeTxn(() async {
      await _isar.discoverys.put(newDiscovery);
    });
    return newDiscovery;
  }

  // Discovery에 sessionId 추가
  Future<void> addSessionIdToDiscovery(int sessionId) async {
    final discovery = await getOrCreateActiveDiscovery();
    if (!discovery.sessionIds.contains(sessionId)) {
      final newSessionIds = List<int>.from(discovery.sessionIds)
        ..add(sessionId);
      discovery.sessionIds = newSessionIds;
      await _isar.writeTxn(() async {
        await _isar.discoverys.put(discovery);
      });
    }
  }

  // Discovery를 완료 처리 (isFinished = true)
  Future<void> finishDiscovery(int discoveryId) async {
    final discovery =
        await _isar.discoverys.filter().idEqualTo(discoveryId).findFirst();
    if (discovery != null && !discovery.isFinished) {
      discovery.isFinished = true;
      await _isar.writeTxn(() async {
        await _isar.discoverys.put(discovery);
      });
    }
  }
}
