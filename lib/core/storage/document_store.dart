import 'dart:convert';

import 'key_value_store.dart';

/// [KeyValueStore] 위에 얹은 컬렉션 저장소.
///
/// 컬렉션 하나가 키 하나에 **JSON 배열 전체**로 직렬화된다. 쓰기마다 컬렉션 전체를
/// 재직렬화하므로 무한히 커지는 데이터에는 맞지 않는다. 이 앱의 규모(세션 수천 건 =
/// 수백 KB)에서는 문제없지만, 수만 건대로 커지면 재설계가 필요하다.
///
/// [load]가 백엔드를 메모리 캐시로 한 번 읽어들이고, 이후 [query]/[getById]는 동기
/// 호출이 된다. 순수 Dart라 인메모리 [KeyValueStore]로 단위 테스트할 수 있다.
class DocumentStore<T> {
  final KeyValueStore _backend;
  final String _collection;
  final Map<String, dynamic> Function(T) _toJson;
  final T Function(Map<String, dynamic>) _fromJson;
  final int? Function(T) _getId;
  final void Function(T, int) _setId;

  final List<T> _items = [];
  int _nextId = 1;
  bool _loaded = false;

  DocumentStore({
    required KeyValueStore backend,
    required String collection,
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
    required int? Function(T) getId,
    required void Function(T, int) setId,
  })  : _backend = backend,
        _collection = collection,
        _toJson = toJson,
        _fromJson = fromJson,
        _getId = getId,
        _setId = setId;

  /// 자동 증가 id의 다음 값을 담는 키.
  ///
  /// 항목 목록과 따로 보관해야 삭제된 id가 재사용되지 않는다.
  String get _sequenceKey => '${_collection}__seq';

  /// 백엔드에서 컬렉션을 읽어 메모리 캐시를 채운다.
  Future<void> load() async {
    _items.clear();

    final raw = await _backend.read(_collection);
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      for (final entry in decoded) {
        _items.add(_fromJson(Map<String, dynamic>.from(entry as Map)));
      }
    }

    final storedSequence = await _backend.read(_sequenceKey);
    _nextId = int.tryParse(storedSequence ?? '') ?? _sequenceFromItems();
    _loaded = true;
  }

  /// 시퀀스 키가 없을 때(최초 실행/외부 주입) 기존 항목에서 다음 id를 유추한다.
  int _sequenceFromItems() {
    var maxId = 0;
    for (final item in _items) {
      final id = _getId(item);
      if (id != null && id > maxId) maxId = id;
    }
    return maxId + 1;
  }

  Future<int> add(T item) async {
    _ensureLoaded();
    final id = _insert(item);
    await _flush();
    return id;
  }

  /// 여러 항목을 한 번의 쓰기로 추가한다. 기본 데이터 시딩에 쓴다.
  Future<void> addAll(Iterable<T> items) async {
    _ensureLoaded();
    for (final item in items) {
      _insert(item);
    }
    await _flush();
  }

  /// id를 확정해 메모리 캐시에 넣고 그 id를 반환한다. 쓰기는 하지 않는다.
  int _insert(T item) {
    final id = _getId(item) ?? _nextId;
    _setId(item, id);
    if (id >= _nextId) _nextId = id + 1;
    _items.add(item);
    return id;
  }

  /// [id]의 항목을 [item]으로 교체한다. 해당 id가 없으면 새로 추가한다.
  Future<void> put(int id, T item) async {
    _ensureLoaded();
    _setId(item, id);
    if (id >= _nextId) _nextId = id + 1;

    final index = _indexOf(id);
    if (index == -1) {
      _items.add(item);
    } else {
      _items[index] = item;
    }
    await _flush();
  }

  Future<void> delete(int id) async {
    _ensureLoaded();
    final index = _indexOf(id);
    if (index == -1) return;
    _items.removeAt(index);
    await _flush();
  }

  /// 조건에 맞는 항목을 모두 지우고 지운 개수를 반환한다.
  Future<int> deleteWhere(bool Function(T) test) async {
    _ensureLoaded();
    final before = _items.length;
    _items.removeWhere(test);
    final removed = before - _items.length;
    if (removed > 0) await _flush();
    return removed;
  }

  /// 컬렉션을 비운다. 자동 증가 시퀀스는 유지해 id 재사용을 막는다.
  Future<void> clear() async {
    _ensureLoaded();
    _items.clear();
    await _backend.delete(_collection);
    await _backend.write(_sequenceKey, '$_nextId');
  }

  T? getById(int id) {
    _ensureLoaded();
    final index = _indexOf(id);
    return index == -1 ? null : _items[index];
  }

  /// 조건/정렬을 적용한 **복사본**을 반환한다. 반환값을 수정해도 저장소는 그대로다.
  List<T> query({bool Function(T)? where, Comparator<T>? sort}) {
    _ensureLoaded();
    final result = where == null ? List<T>.of(_items) : _items.where(where).toList();
    if (sort != null) result.sort(sort);
    return result;
  }

  int get count {
    _ensureLoaded();
    return _items.length;
  }

  int _indexOf(int id) => _items.indexWhere((item) => _getId(item) == id);

  Future<void> _flush() async {
    final encoded = jsonEncode(_items.map(_toJson).toList());
    await _backend.write(_collection, encoded);
    await _backend.write(_sequenceKey, '$_nextId');
  }

  void _ensureLoaded() {
    if (!_loaded) {
      throw StateError('DocumentStore("$_collection")를 load() 전에 사용했습니다.');
    }
  }
}
