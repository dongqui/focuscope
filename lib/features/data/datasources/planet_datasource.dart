import 'package:isar/isar.dart';
import '../models/planet.dart';

class PlanetDataSource {
  final Isar isar;

  PlanetDataSource(this.isar);

  Future<Planet?> getPlanetById(int id) async {
    return await isar.planets.filter().idEqualTo(id).findFirst();
  }

  Future<List<Planet?>> getPlanetsByIds(List<int> ids) async {
    return await isar.planets.getAll(ids);
  }

  Future<void> addDefaultPlanetsIfEmpty() async {
    final count = await isar.planets.count();
    if (count == 0) {
      await isar.writeTxn(() async {
        await isar.planets.putAll(defaultPlanets);
      });
    }
  }
}
