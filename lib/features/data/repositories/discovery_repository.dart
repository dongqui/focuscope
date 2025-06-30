import '../datasources/discovery_datasource.dart';
import '../models/discovery.dart';

class DiscoveryRepository {
  final DiscoveryDataSource dataSource;

  static DiscoveryRepository? _instance;

  DiscoveryRepository._internal(this.dataSource);

  static DiscoveryRepository get instance {
    if (_instance == null) {
      throw Exception(
          "DiscoveryRepository is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  static void initialize(DiscoveryDataSource dataSource) {
    _instance ??= DiscoveryRepository._internal(dataSource);
  }

  Future<Discovery> getOrCreateActiveDiscovery() async {
    return await dataSource.getOrCreateActiveDiscovery();
  }

  Future<void> addSessionIdToDiscovery(int sessionId) async {
    await dataSource.addSessionIdToDiscovery(sessionId);
  }

  Future<void> finishDiscovery(int discoveryId) async {
    await dataSource.finishDiscovery(discoveryId);
  }
}
