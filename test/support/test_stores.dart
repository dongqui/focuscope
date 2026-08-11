import 'package:catodo/core/storage/document_store.dart';

import 'in_memory_key_value_store.dart';

/// 인메모리 백엔드 위에 올린 [DocumentStore]를 만들어 load까지 끝내준다.
Future<DocumentStore<T>> loadedStore<T>({
  required String collection,
  required Map<String, dynamic> Function(T) toJson,
  required T Function(Map<String, dynamic>) fromJson,
  required int? Function(T) getId,
  required void Function(T, int) setId,
  InMemoryKeyValueStore? backend,
}) async {
  final store = DocumentStore<T>(
    backend: backend ?? InMemoryKeyValueStore(),
    collection: collection,
    toJson: toJson,
    fromJson: fromJson,
    getId: getId,
    setId: setId,
  );
  await store.load();
  return store;
}
