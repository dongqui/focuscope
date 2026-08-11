/// 문자열 키-값 저장소 추상화.
///
/// 플랫폼별 구현을 이 인터페이스 뒤에 숨긴다.
/// - 앱인토스 웹뷰: 네이티브 저장소로 브릿지되는 `Storage` API (IndexedDB 7일 삭제 정책 회피)
/// - 그 외 전부: `shared_preferences`
///
/// 문자열만 저장할 수 있다는 앱인토스 제약에 맞춰 값 타입을 String으로 고정한다.
abstract class KeyValueStore {
  /// 백엔드를 준비한다. 사용 전에 한 번 호출해야 한다.
  Future<void> init();

  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}
