import 'package:catodo/features/overlays/data/datasources/latest-activity-datasource.dart';
import 'package:catodo/features/overlays/data/models/latest-activity-model.dart';

class LatestActivityRepository {
  final LatestActivityDataSource dataSource;

  LatestActivityRepository(this.dataSource);

  Future<void> addActivity(LatestActivity activity) {
    return dataSource.addActivity(activity);
  }

  Future<void> deleteActivity(int id) {
    return dataSource.deleteActivity(id);
  }
}
