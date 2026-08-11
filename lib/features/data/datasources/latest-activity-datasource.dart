import 'package:catodo/core/storage/document_store.dart';
import 'package:catodo/features/data/models/latest-activity-model.dart';

class LatestActivityDataSource {
  final DocumentStore<LatestActivity> _store;

  LatestActivityDataSource(this._store);

  Future<void> addActivity(LatestActivity activity) async {
    final id = activity.id;
    if (id == null) {
      await _store.add(activity);
    } else {
      await _store.put(id, activity);
    }
  }

  Future<void> removeLatestActivity(String activity) async {
    await _store.deleteWhere((item) => item.name == activity);
  }

  Future<List<LatestActivity>> getLatestActivities() async {
    return _store.query();
  }
}
