import 'package:catodo/core/storage/key_value_store.dart';

/// 테스트 전용 인메모리 백엔드.
///
/// [DocumentStore]는 순수 Dart이므로 이 구현 하나로 전체 동작을 검증할 수 있다.
/// [snapshot]으로 실제 직렬화된 문자열을 들여다볼 수 있어 라운드트립 확인에 쓴다.
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _data = {};

  /// init()이 몇 번 호출됐는지 — 중복 초기화 검증용.
  int initCount = 0;

  @override
  Future<void> init() async {
    initCount++;
  }

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }

  Map<String, String> get snapshot => Map.unmodifiable(_data);
}
