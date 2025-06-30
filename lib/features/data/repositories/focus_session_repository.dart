import 'package:catodo/features/presentation/viewmodels/chart_state.dart';
import '../datasources/focus_session_datasource.dart';
import '../models/focus_session_model.dart';

class FocusSessionRepository {
  final FocusSessionDataSource dataSource;

  // 싱글톤 인스턴스를 저장할 정적 변수
  static FocusSessionRepository? _instance;

  // 외부에서 데이터 소스를 주입받는 생성자
  FocusSessionRepository._internal(this.dataSource);

  // 싱글톤 인스턴스를 반환하는 정적 getter
  static FocusSessionRepository get instance {
    if (_instance == null) {
      throw Exception(
          "FocusSessionRepository is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  // 초기화 메서드
  static void initialize(FocusSessionDataSource dataSource) {
    _instance ??= FocusSessionRepository._internal(dataSource);
  }

  // FocusSession 저장
  Future<void> addFocusSession(FocusSession session) async {
    await dataSource.addFocusSession(session);
  }

  // FocusSession 불러오기
  Future<List<FocusSession>> getFocusSessions() async {
    return await dataSource.getFocusSessions();
  }

  // 날짜 범위에 따른 FocusSession 불러오기
  Future<List<List<ActivityTimeTuple>>> getFocusSessionsByDateRange(
      DateUnit unit, DateTime date) async {
    return await dataSource.getFocusSessionsByDateRange(unit, date);
  }

  // ID 리스트로 FocusSession 리스트 조회
  Future<List<FocusSession>> getFocusSessionsByIds(List<int> ids) async {
    final sessions = await dataSource.getFocusSessionsByIds(ids);
    return sessions.whereType<FocusSession>().toList();
  }
}
