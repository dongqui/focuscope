import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';

/// `shared_preferences` 기반 [KeyValueStore].
///
/// 앱인토스 웹뷰가 아닌 모든 환경(일반 브라우저, 안드로이드, iOS)의 기본 구현이다.
/// `dart:io`를 요구하지 않으면서 전 플랫폼을 지원하므로 웹 fallback과 모바일 지원이
/// 이것 하나로 해결된다.
///
/// 웹에서는 localStorage로 내려가므로 오리진당 약 5MB 제한이 있다.
class SharedPreferencesStore implements KeyValueStore {
  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<String?> read(String key) async => _requirePrefs().getString(key);

  @override
  Future<void> write(String key, String value) async {
    await _requirePrefs().setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _requirePrefs().remove(key);
  }

  SharedPreferences _requirePrefs() {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('SharedPreferencesStore를 init() 전에 사용했습니다.');
    }
    return prefs;
  }
}
