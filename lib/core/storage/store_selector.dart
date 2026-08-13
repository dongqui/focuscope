import 'package:flutter/foundation.dart';

import 'key_value_store.dart';
import 'shared_preferences_store.dart';
import 'toss_storage_store.dart';

/// 실행 환경에 맞는 [KeyValueStore]를 고른다.
///
/// 앱인토스 웹뷰에서는 네이티브 저장소로 브릿지되는 [TossStorageStore]를 쓴다
/// (IndexedDB 7일 삭제 정책 회피). 감지 실패나 초기화 실패 시에는
/// [SharedPreferencesStore]로 fallback한다.
///
/// 파라미터는 전부 테스트 주입용이다 — 프로덕션에서는 인자 없이 호출한다.
Future<KeyValueStore> createDefaultKeyValueStore({
  bool Function()? isTossAvailable,
  KeyValueStore Function()? createTossStore,
  KeyValueStore Function()? createFallbackStore,
}) async {
  final tossAvailable = isTossAvailable ?? () => TossStorageStore.isAvailable;

  if (tossAvailable()) {
    try {
      final store = (createTossStore ?? TossStorageStore.new)();
      await store.init();
      return store;
    } catch (e) {
      debugPrint('TossStorageStore 초기화 실패, SharedPreferences로 fallback: $e');
    }
  }

  final store = (createFallbackStore ?? SharedPreferencesStore.new)();
  await store.init();
  return store;
}
