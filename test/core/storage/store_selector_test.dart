import 'package:catodo/core/storage/key_value_store.dart';
import 'package:catodo/core/storage/store_selector.dart';
import 'package:catodo/core/storage/toss_storage_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_key_value_store.dart';

/// init()이 항상 실패하는 store — 초기화 실패 fallback 검증용.
class _FailingStore implements KeyValueStore {
  @override
  Future<void> init() async {
    throw StateError('의도된 초기화 실패');
  }

  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}

  @override
  Future<void> delete(String key) async {}
}

void main() {
  group('createDefaultKeyValueStore', () {
    test('앱인토스 환경이면 토스 store를 고르고 init한다', () async {
      final tossStore = InMemoryKeyValueStore();

      final selected = await createDefaultKeyValueStore(
        isTossAvailable: () => true,
        createTossStore: () => tossStore,
        createFallbackStore: () => fail('앱인토스 환경에서는 fallback을 만들면 안 된다'),
      );

      expect(selected, same(tossStore));
      expect(tossStore.initCount, 1);
    });

    test('앱인토스 환경이 아니면 fallback store를 고른다', () async {
      final fallbackStore = InMemoryKeyValueStore();

      final selected = await createDefaultKeyValueStore(
        isTossAvailable: () => false,
        createTossStore: () => fail('미감지 시 토스 store를 만들면 안 된다'),
        createFallbackStore: () => fallbackStore,
      );

      expect(selected, same(fallbackStore));
      expect(fallbackStore.initCount, 1);
    });

    test('토스 store 초기화가 실패하면 fallback으로 넘어간다', () async {
      final fallbackStore = InMemoryKeyValueStore();

      final selected = await createDefaultKeyValueStore(
        isTossAvailable: () => true,
        createTossStore: () => _FailingStore(),
        createFallbackStore: () => fallbackStore,
      );

      expect(selected, same(fallbackStore));
      expect(fallbackStore.initCount, 1);
    });

    test('VM(비웹) 빌드에서는 TossStorageStore가 사용 불가로 감지된다', () {
      expect(TossStorageStore.isAvailable, isFalse);
    });
  });
}
