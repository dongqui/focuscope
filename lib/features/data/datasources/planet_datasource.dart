import 'package:catodo/core/storage/document_store.dart';

import '../models/planet.dart';

class PlanetDataSource {
  final DocumentStore<Planet> _store;

  PlanetDataSource(this._store);

  Future<Planet?> getPlanetById(int id) async {
    return _store.getById(id);
  }

  Future<List<Planet?>> getPlanetsByIds(List<int> ids) async {
    return ids.map(_store.getById).toList();
  }

  Future<void> addDefaultPlanetsIfEmpty() async {
    if (_store.count > 0) return;
    // 시드 상수를 저장소와 공유하지 않도록 복사해서 넣는다.
    await _store.addAll(defaultPlanets.map((p) => Planet.fromJson(p.toJson())));
  }

  // 행성 업데이트 또는 추가
  Future<void> updatePlanet(Planet planet) async {
    await _store.put(planet.id, planet);
  }

  /// Discovery가 아직 쓰지 않은 행성을 고르기 위해 전체 목록이 필요하다.
  List<Planet> all() => _store.query();
}
