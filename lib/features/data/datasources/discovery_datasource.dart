import 'package:catodo/core/storage/document_store.dart';

import '../models/discovery.dart';
import '../models/planet.dart';

class DiscoveryDataSource {
  final DocumentStore<Discovery> _store;
  final DocumentStore<Planet> _planetStore;

  DiscoveryDataSource(this._store, this._planetStore);

  // isFinished가 false인 Discovery를 불러오고, 없으면 새로 생성
  Future<Discovery> getOrCreateActiveDiscovery() async {
    // 1. isFinished == false인 Discovery 찾기
    final active = _store.query(where: (d) => !d.isFinished);
    if (active.isNotEmpty) {
      return active.first;
    }
    // 2. planetId 후보군 구하기
    final planets = _planetStore.query();
    final usedPlanetIds = _store.query().map((d) => d.planetId).toSet();
    int newPlanetId = planets.map((p) => p.id).firstWhere(
          (id) => !usedPlanetIds.contains(id),
          orElse: () => 1025,
        );
    // 3. 새 Discovery 생성
    final newDiscovery = Discovery(
      sessionIds: [],
      planetId: newPlanetId,
      isFinished: false,
    );
    await _store.add(newDiscovery);
    return newDiscovery;
  }

  // Discovery에 sessionId 추가
  Future<void> addSessionIdToDiscovery(int sessionId) async {
    final discovery = await getOrCreateActiveDiscovery();
    if (!discovery.sessionIds.contains(sessionId)) {
      final newSessionIds = List<int>.from(discovery.sessionIds)
        ..add(sessionId);
      discovery.sessionIds = newSessionIds;
      await _store.put(discovery.id!, discovery);
    }
  }

  // Discovery를 완료 처리 (isFinished = true)
  Future<void> finishDiscovery(int discoveryId) async {
    final discovery = _store.getById(discoveryId);
    if (discovery != null && !discovery.isFinished) {
      discovery.isFinished = true;
      await _store.put(discoveryId, discovery);
    }
  }

  // isFinished가 true인 Discovery 리스트 반환
  Future<List<Discovery>> getFinishedDiscoveries() async {
    return _store.query(where: (d) => d.isFinished);
  }
}
