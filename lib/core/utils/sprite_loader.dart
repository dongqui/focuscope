import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:http/http.dart' as http;

/// 원격 바이트를 가져오는 함수. 테스트에서 주입할 수 있도록 분리했다.
typedef BytesFetcher = Future<Uint8List> Function(Uri uri);

Future<Uint8List> _httpFetch(Uri uri) => http.readBytes(uri);

/// 번들 에셋 경로와 원격 URL을 모두 처리하는 스프라이트 로더.
///
/// `Flame.images.load()`는 에셋 번들 전용이라 원격 URL을 처리하지 못한다.
/// 리소스를 파일로 내려받는 대신 서버 URL에서 바로 읽도록 바뀌면서 필요해졌다.
///
/// - `http`/`https`로 시작하면 네트워크에서 받아 [cache]에 URL을 키로 넣는다.
///   같은 URL을 다시 요청하면 캐시가 응답하므로 네트워크를 다시 타지 않는다.
/// - 그 외에는 번들 에셋으로 간주해 Flame 기본 경로(`assets/images/`)에서 읽는다.
/// - 원격 로드가 실패했고 [fallbackAsset]이 주어지면 그 번들 에셋으로 대체한다.
///   주어지지 않으면 예외를 그대로 던진다.
Future<ui.Image> loadSprite(
  String pathOrUrl, {
  Images? cache,
  BytesFetcher? fetch,
  String? fallbackAsset,
}) async {
  final images = cache ?? Flame.images;

  if (!_isRemote(pathOrUrl)) {
    return images.load(pathOrUrl);
  }

  if (images.containsKey(pathOrUrl)) {
    return images.fromCache(pathOrUrl);
  }

  try {
    final bytes = await (fetch ?? _httpFetch)(Uri.parse(pathOrUrl));
    final image = await _decode(bytes);
    images.add(pathOrUrl, image);
    return image;
  } catch (_) {
    if (fallbackAsset == null) rethrow;
    return images.load(fallbackAsset);
  }
}

bool _isRemote(String pathOrUrl) =>
    pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://');

Future<ui.Image> _decode(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}
