import 'package:catodo/core/storage/shared_preferences_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferencesStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = SharedPreferencesStore();
    await store.init();
  });

  test('쓴 값을 그대로 읽는다', () async {
    await store.write('items', '[{"id":1}]');

    expect(await store.read('items'), '[{"id":1}]');
  });

  test('없는 키는 null을 반환한다', () async {
    expect(await store.read('없는키'), isNull);
  });

  test('덮어쓰면 마지막 값이 남는다', () async {
    await store.write('items', 'first');
    await store.write('items', 'second');

    expect(await store.read('items'), 'second');
  });

  test('delete하면 다시 null이 된다', () async {
    await store.write('items', 'value');

    await store.delete('items');

    expect(await store.read('items'), isNull);
  });

  test('새 인스턴스에서도 저장된 값을 읽는다', () async {
    await store.write('items', 'persisted');

    final reopened = SharedPreferencesStore();
    await reopened.init();

    expect(await reopened.read('items'), 'persisted');
  });

  test('init 전에 사용하면 StateError를 던진다', () {
    final fresh = SharedPreferencesStore();

    expect(() => fresh.read('items'), throwsStateError);
  });
}
