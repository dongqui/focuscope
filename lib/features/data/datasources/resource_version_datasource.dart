import 'package:catodo/core/storage/document_store.dart';

import '../models/resource_version.dart';

class ResourceVersionDataSource {
  final DocumentStore<ResourceVersion> _store;

  ResourceVersionDataSource(this._store);

  /// 리소스 버전 정보 저장 또는 업데이트.
  ///
  /// 로컬 리소스 버전은 항상 한 벌만 존재한다. 새로 저장하면 기존 값을 교체한다.
  Future<void> saveResourceVersion(ResourceVersion version) async {
    final existing = _store.query();
    if (existing.isEmpty) {
      await _store.add(version);
      return;
    }
    await _store.put(existing.first.id!, version);
  }

  Future<void> addDefaultResourceVersionIfEmpty() async {
    if (_store.count > 0) return;
    await _store.add(ResourceVersion.fromJson(defaultResourceVersion.toJson()));
  }

  /// 디바이스 저장소에서 현재 리소스 버전을 가져옵니다
  Future<ResourceVersion?> getCurrentResourceVersion() async {
    final versions = _store.query();
    return versions.isNotEmpty ? versions.first : null;
  }
}
