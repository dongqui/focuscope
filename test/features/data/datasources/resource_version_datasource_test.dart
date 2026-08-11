import 'package:catodo/core/storage/document_store.dart';
import 'package:catodo/features/data/datasources/resource_version_datasource.dart';
import 'package:catodo/features/data/models/resource_version.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/test_stores.dart';

Future<DocumentStore<ResourceVersion>> buildStore() =>
    loadedStore<ResourceVersion>(
      collection: 'resourceVersions',
      toJson: (v) => v.toJson(),
      fromJson: ResourceVersion.fromJson,
      getId: (v) => v.id,
      setId: (v, id) => v.id = id,
    );

void main() {
  late DocumentStore<ResourceVersion> store;
  late ResourceVersionDataSource dataSource;

  setUp(() async {
    store = await buildStore();
    dataSource = ResourceVersionDataSource(store);
  });

  test('저장된 버전이 없으면 null을 반환한다', () async {
    expect(await dataSource.getCurrentResourceVersion(), isNull);
  });

  test('addDefaultResourceVersionIfEmpty는 비어 있을 때 기본 버전을 넣는다', () async {
    await dataSource.addDefaultResourceVersionIfEmpty();

    final current = await dataSource.getCurrentResourceVersion();
    expect(current?.version, 1);
  });

  test('addDefaultResourceVersionIfEmpty는 이미 값이 있으면 덮어쓰지 않는다', () async {
    await dataSource
        .saveResourceVersion(ResourceVersion(version: 9, checkedAt: DateTime(2026, 8, 10)));

    await dataSource.addDefaultResourceVersionIfEmpty();

    final current = await dataSource.getCurrentResourceVersion();
    expect(current?.version, 9);
  });

  test('saveResourceVersion은 기존 버전을 교체한다', () async {
    await dataSource
        .saveResourceVersion(ResourceVersion(version: 1, checkedAt: DateTime(2026, 8, 1)));

    await dataSource.saveResourceVersion(
        ResourceVersion(version: 2, checkedAt: DateTime(2026, 8, 11)));

    final current = await dataSource.getCurrentResourceVersion();
    expect(current?.version, 2);
    expect(current?.checkedAt, DateTime(2026, 8, 11));
  });

  test('saveResourceVersion을 반복해도 행이 쌓이지 않는다', () async {
    for (var v = 1; v <= 5; v++) {
      await dataSource
          .saveResourceVersion(ResourceVersion(version: v, checkedAt: DateTime(2026, 8, v)));
    }

    expect(store.count, 1);
  });
}
