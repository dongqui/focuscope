import '../datasources/planet_datasource.dart';
import '../models/planet.dart';

class PlanetRepository {
  final PlanetDataSource dataSource;

  // 싱글톤 인스턴스를 저장할 정적 변수
  static PlanetRepository? _instance;
  // 외부에서 데이터 소스를 주입받는 생성자
  PlanetRepository._internal(this.dataSource);

  // 싱글톤 인스턴스를 반환하는 정적 getter
  static PlanetRepository get instance {
    if (_instance == null) {
      throw Exception(
          "PlanetRepository is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  static void initialize(PlanetDataSource dataSource) {
    _instance ??= PlanetRepository._internal(dataSource);
  }

  Future<Planet?> getPlanetById(int id) async {
    return await dataSource.getPlanetById(id);
  }

  Future<List<Planet?>> getPlanetsByIds(List<int> ids) async {
    return await dataSource.getPlanetsByIds(ids);
  }

  Future<void> addDefaultPlanetsIfEmpty() async {
    await dataSource.addDefaultPlanetsIfEmpty();
  }
}
