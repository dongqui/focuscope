import 'dart:convert';
import 'dart:typed_data';

import 'package:catodo/core/utils/sprite_loader.dart';
import 'package:flame/cache.dart';
import 'package:flutter_test/flutter_test.dart';

/// 1x1 투명 PNG. 디코딩만 통과하면 되므로 최소 크기로 둔다.
final Uint8List onePixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Images cache;
  late List<Uri> requested;

  setUp(() {
    cache = Images();
    requested = [];
  });

  Future<Uint8List> fakeFetch(Uri uri) async {
    requested.add(uri);
    return onePixelPng;
  }

  test('http URL이면 네트워크에서 받아 이미지로 만든다', () async {
    final image = await loadSprite(
      'https://cdn.example.com/planets/mars.png',
      cache: cache,
      fetch: fakeFetch,
    );

    expect(image.width, 1);
    expect(requested.single.toString(),
        'https://cdn.example.com/planets/mars.png');
  });

  test('같은 URL을 다시 요청하면 네트워크를 다시 타지 않는다', () async {
    const url = 'https://cdn.example.com/planets/mars.png';

    final first = await loadSprite(url, cache: cache, fetch: fakeFetch);
    final second = await loadSprite(url, cache: cache, fetch: fakeFetch);

    expect(requested.length, 1);
    expect(identical(first, second), isTrue);
  });

  test('https가 아닌 http URL도 원격으로 취급한다', () async {
    await loadSprite(
      'http://cdn.example.com/planets/mars.png',
      cache: cache,
      fetch: fakeFetch,
    );

    expect(requested, hasLength(1));
  });

  test('번들 에셋 경로면 네트워크를 타지 않는다', () async {
    final image = await loadSprite(
      'characters/astronaut_idle.png',
      cache: cache,
      fetch: fakeFetch,
    );

    expect(requested, isEmpty);
    expect(image.width, greaterThan(0));
  });

  test('원격 로드가 실패하면 fallback 번들 에셋을 쓴다', () async {
    Future<Uint8List> failingFetch(Uri uri) async {
      requested.add(uri);
      throw Exception('네트워크 실패');
    }

    final image = await loadSprite(
      'https://cdn.example.com/없는파일.png',
      cache: cache,
      fetch: failingFetch,
      fallbackAsset: 'characters/astronaut_idle.png',
    );

    expect(requested, hasLength(1));
    expect(image.width, greaterThan(0));
  });

  test('fallback이 없으면 원격 실패를 그대로 던진다', () async {
    Future<Uint8List> failingFetch(Uri uri) async => throw Exception('네트워크 실패');

    expect(
      () => loadSprite(
        'https://cdn.example.com/없는파일.png',
        cache: cache,
        fetch: failingFetch,
      ),
      throwsException,
    );
  });
}
