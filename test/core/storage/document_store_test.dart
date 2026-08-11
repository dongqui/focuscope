import 'dart:convert';

import 'package:catodo/core/storage/document_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_key_value_store.dart';

/// 테스트용 모델. 자동 증가 id를 쓰는 모델(FocusSession 등)을 대표한다.
class Item {
  int? id;
  String name;
  int value;

  Item({this.id, required this.name, required this.value});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'value': value};

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as int?,
        name: json['name'] as String,
        value: json['value'] as int,
      );
}

DocumentStore<Item> buildStore(InMemoryKeyValueStore backend) {
  return DocumentStore<Item>(
    backend: backend,
    collection: 'items',
    toJson: (item) => item.toJson(),
    fromJson: Item.fromJson,
    getId: (item) => item.id,
    setId: (item, id) => item.id = id,
  );
}

void main() {
  late InMemoryKeyValueStore backend;
  late DocumentStore<Item> store;

  setUp(() async {
    backend = InMemoryKeyValueStore();
    store = buildStore(backend);
    await store.load();
  });

  group('add', () {
    test('id가 없는 항목에 1부터 시작하는 id를 부여한다', () async {
      final first = await store.add(Item(name: 'a', value: 1));
      final second = await store.add(Item(name: 'b', value: 2));

      expect(first, 1);
      expect(second, 2);
    });

    test('부여한 id를 항목 자체에도 기록한다', () async {
      final item = Item(name: 'a', value: 1);

      await store.add(item);

      expect(item.id, 1);
    });

    test('이미 id가 있는 항목은 그 id를 그대로 쓴다', () async {
      final id = await store.add(Item(id: 42, name: 'fixed', value: 1));

      expect(id, 42);
      expect(store.getById(42)?.name, 'fixed');
    });

    test('고정 id를 쓴 뒤의 자동 id는 그보다 큰 값이 된다', () async {
      await store.add(Item(id: 42, name: 'fixed', value: 1));

      final next = await store.add(Item(name: 'auto', value: 2));

      expect(next, 43);
    });
  });

  group('addAll', () {
    test('고정 id를 가진 시드 데이터를 그대로 보존한다', () async {
      await store.addAll([
        Item(id: 1, name: 'astronaut', value: 1),
        Item(id: 2, name: 'dog_white', value: 2),
      ]);

      expect(store.query().map((i) => i.id), [1, 2]);
      expect(store.getById(2)?.name, 'dog_white');
    });
  });

  group('query', () {
    setUp(() async {
      await store.add(Item(name: 'b', value: 2));
      await store.add(Item(name: 'a', value: 3));
      await store.add(Item(name: 'c', value: 1));
    });

    test('인자가 없으면 전체를 반환한다', () {
      expect(store.query().length, 3);
    });

    test('where로 필터링한다', () {
      final result = store.query(where: (item) => item.value >= 2);

      expect(result.map((i) => i.name).toSet(), {'b', 'a'});
    });

    test('sort로 정렬한다', () {
      final result = store.query(sort: (a, b) => a.value.compareTo(b.value));

      expect(result.map((i) => i.name), ['c', 'b', 'a']);
    });

    test('반환된 리스트를 수정해도 저장소에 영향을 주지 않는다', () {
      store.query().clear();

      expect(store.query().length, 3);
    });
  });

  group('getById', () {
    test('존재하는 id의 항목을 반환한다', () async {
      final id = await store.add(Item(name: 'a', value: 1));

      expect(store.getById(id)?.name, 'a');
    });

    test('존재하지 않는 id에는 null을 반환한다', () {
      expect(store.getById(999), isNull);
    });
  });

  group('put', () {
    test('같은 id의 기존 항목을 교체한다', () async {
      final id = await store.add(Item(name: 'before', value: 1));

      await store.put(id, Item(name: 'after', value: 2));

      expect(store.query().length, 1);
      expect(store.getById(id)?.name, 'after');
    });

    test('교체된 항목에 id를 기록한다', () async {
      final id = await store.add(Item(name: 'before', value: 1));
      final replacement = Item(name: 'after', value: 2);

      await store.put(id, replacement);

      expect(replacement.id, id);
    });

    test('없던 id로 put하면 새 항목으로 추가된다', () async {
      await store.put(7, Item(name: 'new', value: 1));

      expect(store.getById(7)?.name, 'new');
    });
  });

  group('delete', () {
    test('id로 항목을 제거한다', () async {
      final id = await store.add(Item(name: 'a', value: 1));

      await store.delete(id);

      expect(store.getById(id), isNull);
      expect(store.query(), isEmpty);
    });

    test('deleteWhere는 조건에 맞는 항목을 모두 지우고 개수를 반환한다', () async {
      await store.add(Item(name: 'keep', value: 1));
      await store.add(Item(name: 'drop', value: 2));
      await store.add(Item(name: 'drop', value: 3));

      final removed = await store.deleteWhere((item) => item.name == 'drop');

      expect(removed, 2);
      expect(store.query().map((i) => i.name), ['keep']);
    });

    test('clear는 컬렉션을 비운다', () async {
      await store.add(Item(name: 'a', value: 1));
      await store.add(Item(name: 'b', value: 2));

      await store.clear();

      expect(store.query(), isEmpty);
    });
  });

  group('영속성', () {
    test('같은 백엔드로 다시 load하면 데이터가 남아 있다', () async {
      await store.add(Item(name: 'a', value: 1));
      await store.add(Item(name: 'b', value: 2));

      final reopened = buildStore(backend);
      await reopened.load();

      expect(reopened.query().map((i) => i.name), ['a', 'b']);
    });

    test('재시작 후에도 id가 이어서 부여된다', () async {
      await store.add(Item(name: 'a', value: 1));
      await store.add(Item(name: 'b', value: 2));

      final reopened = buildStore(backend);
      await reopened.load();
      final next = await reopened.add(Item(name: 'c', value: 3));

      expect(next, 3);
    });

    test('삭제 후 재시작해도 지워진 id가 재사용되지 않는다', () async {
      await store.add(Item(name: 'a', value: 1));
      final second = await store.add(Item(name: 'b', value: 2));
      await store.delete(second);

      final reopened = buildStore(backend);
      await reopened.load();
      final next = await reopened.add(Item(name: 'c', value: 3));

      expect(next, 3);
    });

    test('컬렉션 하나가 키 하나에 JSON 배열로 저장된다', () async {
      await store.add(Item(name: 'a', value: 1));

      final raw = backend.snapshot['items'];
      expect(raw, isNotNull);
      final decoded = jsonDecode(raw!) as List;
      expect(decoded.single, {'id': 1, 'name': 'a', 'value': 1});
    });

    test('clear는 백엔드의 키까지 정리한다', () async {
      await store.add(Item(name: 'a', value: 1));

      await store.clear();

      final reopened = buildStore(backend);
      await reopened.load();
      expect(reopened.query(), isEmpty);
    });
  });

  group('load', () {
    test('저장된 데이터가 없으면 빈 컬렉션으로 시작한다', () {
      expect(store.query(), isEmpty);
    });

    test('load 전에 query를 호출하면 StateError를 던진다', () {
      final fresh = buildStore(backend);

      expect(() => fresh.query(), throwsStateError);
    });
  });
}
