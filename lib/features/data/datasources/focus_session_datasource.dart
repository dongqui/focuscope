import 'package:catodo/core/storage/document_store.dart';
import 'package:catodo/core/utils/date_helper.dart';
import 'package:catodo/features/presentation/viewmodels/chart_state.dart';

import '../models/focus_session_model.dart';

class FocusSessionDataSource {
  final DocumentStore<FocusSession> _store;

  FocusSessionDataSource(this._store);

  // FocusSession 저장 함수
  Future<int> addFocusSession(FocusSession session) async {
    return await _store.add(session);
  }

  // FocusSession 불러오기 함수
  Future<List<FocusSession>> getFocusSessions() async {
    return _store.query(sort: (a, b) => a.date.compareTo(b.date));
  }

  // 액티비티와 집중 시간을 나타내는 튜플 타입

  // 날짜 범위에 따른 FocusSession 불러오기 함수
  Future<List<List<ActivityTimeTuple>>> getFocusSessionsByDateRange(
      DateUnit unit, DateTime date) async {
    DateTime startDate;
    DateTime endDate;
    int timeSlots;

    switch (unit) {
      case DateUnit.day:
        startDate = DateHelper.getDayStart(date);
        endDate = DateHelper.getDayEnd(date);
        timeSlots = 24; // 24시간
        break;
      case DateUnit.week:
        startDate = DateHelper.getWeekStart(date);
        endDate = DateHelper.getWeekEnd(date);
        timeSlots = 7; // 7일
        break;
      case DateUnit.month:
        startDate = DateHelper.getMonthStart(date);
        endDate = DateHelper.getMonthEnd(date);
        timeSlots = endDate.day; // 실제 달의 일수 사용
        break;
      case DateUnit.year:
        startDate = DateHelper.getYearStart(date);
        endDate = DateHelper.getYearEnd(date);
        timeSlots = 12; // 12개월
        break;
    }

    // 양끝 경계를 포함한다 (기존 Isar 필터의 include: true와 동일)
    final sessions = _store.query(
      where: (session) =>
          !session.date.isBefore(startDate) && !session.date.isAfter(endDate),
      sort: (a, b) => a.date.compareTo(b.date),
    );

    // 시간대별로 그룹화된 결과를 저장할 리스트
    List<List<ActivityTimeTuple>> result = List.generate(timeSlots, (_) => []);

    for (var session in sessions) {
      int timeSlot;
      switch (unit) {
        case DateUnit.day:
          timeSlot = session.date.hour;
          break;
        case DateUnit.week:
          timeSlot = session.date.weekday - 1; // 0-6
          break;
        case DateUnit.month:
          timeSlot = session.date.day - 1; // 0-29
          break;
        case DateUnit.year:
          timeSlot = session.date.month - 1; // 0-11
          break;
      }

      // 해당 시간대의 기존 액티비티 목록에서 현재 액티비티 찾기
      var existingActivityIndex =
          result[timeSlot].indexWhere((tuple) => tuple.$1 == session.activity);

      if (existingActivityIndex != -1) {
        // 기존 액티비티가 있으면 집중 시간 누적
        var existingTuple = result[timeSlot][existingActivityIndex];
        result[timeSlot][existingActivityIndex] =
            (existingTuple.$1, existingTuple.$2 + session.focusedTime);
      } else {
        // 새로운 액티비티면 추가
        result[timeSlot].add((session.activity, session.focusedTime));
      }
    }

    return result;
  }

  // ID 리스트로 FocusSession 리스트 조회
  Future<List<FocusSession?>> getFocusSessionsByIds(List<int> ids) async {
    return ids.map(_store.getById).toList();
  }
}
