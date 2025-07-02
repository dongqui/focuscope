import 'package:isar/isar.dart';
import 'package:catodo/features/data/models/latest-activity-model.dart';

class LatestActivityDataSource {
  final Isar _isar;

  LatestActivityDataSource(this._isar);

  Future<void> addActivity(LatestActivity activity) async {
    await _isar.writeTxn(() async {
      await _isar.latestActivitys.put(activity);
    });
  }

  Future<void> removeLatestActivity(String activity) async {
    await _isar.writeTxn(() async {
      await _isar.latestActivitys.filter().nameEqualTo(activity).deleteAll();
    });
  }

  Future<List<LatestActivity>> getLatestActivities() async {
    return await _isar.latestActivitys.where().findAll();
  }
}
