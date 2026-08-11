import 'package:catodo/core/storage/document_store.dart';
import 'package:catodo/features/data/datasources/focus_session_datasource.dart';
import 'package:catodo/features/data/models/focus_session_model.dart';
import 'package:catodo/features/presentation/viewmodels/chart_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/test_stores.dart';

Future<DocumentStore<FocusSession>> buildStore() => loadedStore<FocusSession>(
      collection: 'focusSessions',
      toJson: (s) => s.toJson(),
      fromJson: FocusSession.fromJson,
      getId: (s) => s.id,
      setId: (s, id) => s.id = id,
    );

FocusSession session(String activity, DateTime date, {int focusedTime = 60}) =>
    FocusSession(
      activity: activity,
      focusedTime: focusedTime,
      restTime: 0,
      date: date,
    );

void main() {
  late DocumentStore<FocusSession> store;
  late FocusSessionDataSource dataSource;

  setUp(() async {
    store = await buildStore();
    dataSource = FocusSessionDataSource(store);
  });

  group('기본 조회', () {
    test('addFocusSession은 부여된 id를 반환한다', () async {
      final id = await dataSource.addFocusSession(
        session('공부', DateTime(2026, 8, 11, 10)),
      );

      expect(id, 1);
    });

    test('getFocusSessions는 날짜 오름차순으로 반환한다', () async {
      await dataSource.addFocusSession(session('늦음', DateTime(2026, 8, 11)));
      await dataSource.addFocusSession(session('이름', DateTime(2026, 8, 9)));
      await dataSource.addFocusSession(session('중간', DateTime(2026, 8, 10)));

      final result = await dataSource.getFocusSessions();

      expect(result.map((s) => s.activity), ['이름', '중간', '늦음']);
    });

    test('getFocusSessionsByIds는 없는 id에 null을 반환한다', () async {
      final id = await dataSource.addFocusSession(
        session('공부', DateTime(2026, 8, 11, 10)),
      );

      final result = await dataSource.getFocusSessionsByIds([id, 999]);

      expect(result.first?.activity, '공부');
      expect(result.last, isNull);
    });
  });

  group('getFocusSessionsByDateRange - day', () {
    test('세션을 시간(hour) 슬롯에 넣고 24칸을 반환한다', () async {
      await dataSource
          .addFocusSession(session('공부', DateTime(2026, 8, 11, 9), focusedTime: 100));

      final result = await dataSource.getFocusSessionsByDateRange(
        DateUnit.day,
        DateTime(2026, 8, 11),
      );

      expect(result.length, 24);
      expect(result[9], [('공부', 100)]);
      expect(result[10], isEmpty);
    });

    test('같은 시간대 같은 액티비티는 집중 시간을 누적한다', () async {
      await dataSource.addFocusSession(
          session('공부', DateTime(2026, 8, 11, 9, 5), focusedTime: 100));
      await dataSource.addFocusSession(
          session('공부', DateTime(2026, 8, 11, 9, 40), focusedTime: 50));

      final result = await dataSource.getFocusSessionsByDateRange(
        DateUnit.day,
        DateTime(2026, 8, 11),
      );

      expect(result[9], [('공부', 150)]);
    });

    test('같은 시간대 다른 액티비티는 따로 쌓인다', () async {
      await dataSource.addFocusSession(
          session('공부', DateTime(2026, 8, 11, 9, 5), focusedTime: 100));
      await dataSource.addFocusSession(
          session('독서', DateTime(2026, 8, 11, 9, 40), focusedTime: 50));

      final result = await dataSource.getFocusSessionsByDateRange(
        DateUnit.day,
        DateTime(2026, 8, 11),
      );

      expect(result[9], [('공부', 100), ('독서', 50)]);
    });

    test('다른 날짜의 세션은 제외한다', () async {
      await dataSource
          .addFocusSession(session('어제', DateTime(2026, 8, 10, 9)));
      await dataSource
          .addFocusSession(session('내일', DateTime(2026, 8, 12, 9)));

      final result = await dataSource.getFocusSessionsByDateRange(
        DateUnit.day,
        DateTime(2026, 8, 11),
      );

      expect(result.every((slot) => slot.isEmpty), isTrue);
    });

    // 경계는 DateHelper.getDayStart/getDayEnd가 정한다. getDayEnd는 23:59:59.000이라
    // 마지막 1초의 밀리초 구간(23:59:59.001~.999)은 빠진다 — Isar 시절부터의 동작이다.
    test('그 날의 첫 순간과 마지막 순간도 포함한다', () async {
      await dataSource.addFocusSession(
          session('자정', DateTime(2026, 8, 11, 0, 0, 0), focusedTime: 10));
      await dataSource.addFocusSession(
          session('끝', DateTime(2026, 8, 11, 23, 59, 59), focusedTime: 20));

      final result = await dataSource.getFocusSessionsByDateRange(
        DateUnit.day,
        DateTime(2026, 8, 11),
      );

      expect(result[0], [('자정', 10)]);
      expect(result[23], [('끝', 20)]);
    });
  });

  group('getFocusSessionsByDateRange - 그 외 단위', () {
    test('week는 7칸을 요일 슬롯으로 반환한다', () async {
      // 2026-08-11은 화요일 → weekday 2 → 슬롯 1
      await dataSource
          .addFocusSession(session('화요일', DateTime(2026, 8, 11, 9), focusedTime: 30));

      final result = await dataSource.getFocusSessionsByDateRange(
        DateUnit.week,
        DateTime(2026, 8, 11),
      );

      expect(result.length, 7);
      expect(result[1], [('화요일', 30)]);
    });

    test('month는 그 달의 일수만큼 칸을 만든다', () async {
      await dataSource
          .addFocusSession(session('11일', DateTime(2026, 8, 11, 9), focusedTime: 30));

      final result = await dataSource.getFocusSessionsByDateRange(
        DateUnit.month,
        DateTime(2026, 8, 11),
      );

      expect(result.length, 31);
      expect(result[10], [('11일', 30)]);
    });

    test('year는 12칸을 월 슬롯으로 반환한다', () async {
      await dataSource
          .addFocusSession(session('8월', DateTime(2026, 8, 11, 9), focusedTime: 30));

      final result = await dataSource.getFocusSessionsByDateRange(
        DateUnit.year,
        DateTime(2026, 8, 11),
      );

      expect(result.length, 12);
      expect(result[7], [('8월', 30)]);
    });
  });
}
