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

  Future<void> deleteActivity(int id) async {
    await _isar.writeTxn(() async {
      await _isar.latestActivitys.delete(id);
    });
  }
}
