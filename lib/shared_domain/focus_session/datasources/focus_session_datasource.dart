import 'package:isar/isar.dart';

import '../models/focus_session_model.dart';

class FocusSessionDataSource {
  final Isar _isar;

  FocusSessionDataSource(this._isar);

  // FocusSession 저장 함수
  Future<void> addFocusSession(FocusSession session) async {
    await _isar.writeTxn(() async {
      await _isar.focusSessions.put(session);
    });
  }

// FocusSession 불러오기 함수
  Future<List<FocusSession>> getFocusSessions() async {
    return await _isar.focusSessions.where().sortByDate().findAll();
  }
}
