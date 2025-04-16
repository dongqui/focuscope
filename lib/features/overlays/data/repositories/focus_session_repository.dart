import '../datasources/focus_session_datasource.dart';
import '../models/focus_session_model.dart';

class FocusSessionRepository {
  final FocusSessionDataSource dataSource;

  FocusSessionRepository(this.dataSource);

  // FocusSession 저장
  Future<void> addFocusSession(FocusSession session) async {
    await dataSource.addFocusSession(session);
  }

  // FocusSession 불러오기
  Future<List<FocusSession>> getFocusSessions() async {
    return await dataSource.getFocusSessions();
  }
}
