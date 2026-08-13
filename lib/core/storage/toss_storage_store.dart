/// 앱인토스 Storage API 기반 [KeyValueStore]의 플랫폼 분기 지점.
///
/// 웹(js_interop 사용 가능) 빌드에서는 실제 구현이, 그 외(모바일) 빌드에서는
/// `isAvailable == false`인 stub이 노출된다. `dart:js_interop`을 네이티브에서
/// 직접 import하면 컴파일이 실패하므로 이 분기가 필요하다.
library;

export 'toss_storage_store_stub.dart'
    if (dart.library.js_interop) 'toss_storage_store_web.dart';
