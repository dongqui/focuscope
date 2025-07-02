import 'package:catodo/features/data/datasources/latest-activity-datasource.dart';
import 'package:catodo/features/data/models/latest-activity-model.dart';

class LatestActivityRepository {
  final LatestActivityDataSource dataSource;

  // 싱글톤 인스턴스를 저장할 정적 변수
  static LatestActivityRepository? _instance;
  // 외부에서 데이터 소스를 주입받는 생성자
  LatestActivityRepository._internal(this.dataSource);

  // 싱글톤 인스턴스를 반환하는 정적 getter
  static LatestActivityRepository get instance {
    if (_instance == null) {
      throw Exception(
          "FocusSessionRepository is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  // 초기화 메서드
  static void initialize(LatestActivityDataSource dataSource) {
    _instance ??= LatestActivityRepository._internal(dataSource);
  }

  Future<void> addLatestActivity(LatestActivity activity) {
    return dataSource.addActivity(activity);
  }

  Future<void> removeLatestActivity(String activity) {
    return dataSource.removeLatestActivity(activity);
  }

  Future<List<LatestActivity>> getLatestActivities() async {
    return await dataSource.getLatestActivities();
  }
}
