# Flutter Web 전환 설계 — 앱인토스(Apps in Toss) 미니앱 출품

- 작성일: 2026-08-08
- 작업 브랜치: `refactor/web-build` (분기 지점 `78e35f4`)
- 상태: 설계 승인 완료, 구현 미착수

## 1. 목표와 범위

`catodo`(repo: `focuscope`) Flutter 앱을 **웹으로 전환**하여 **앱인토스 미니앱으로 출품**한다.

확정된 전제:

| 항목 | 결정 |
|---|---|
| 웹 범위 | 웹으로 전환. 모바일 빌드는 후순위 (깨지지 않게는 유지하되 우선순위 아님) |
| 기존 데이터 마이그레이션 | **불필요** — 미출시/개발 중이라 온디바이스 데이터를 버려도 됨 |
| 리소스(캐릭터/행성 이미지) | 파일 다운로드 폐기, **서버 URL 직접 로드**로 전환 |
| 영속성 | DB 패키지 없이 **저장소 추상화 + 플랫폼별 어댑터** 직접 구현 |

## 2. 현황 진단

### 2.1 컴파일 자체가 불가능한 블로커

- `import 'dart:io'` — `lib/main.dart:1`, `lib/core/utils/path_helper.dart:1`, `lib/features/data/services/resource_update_service.dart:1`
  Flutter Web은 JS/wasm으로 컴파일되므로 `File`/`Directory`가 아예 존재하지 않는다. 플랫폼이 무엇을 허용하느냐와 무관한 컴파일 단계 사실이다.
- `isar_flutter_libs` — 네이티브 바이너리 의존. Isar 3는 사실상 유지보수 중단 상태.
- `web/` 디렉토리 부재.

### 2.2 컴파일은 되지만 런타임에 깨지는 것

- `path_provider.getApplicationDocumentsDirectory()` — 웹 구현 없음.
  사용처: `core/db.dart:36`, `core/utils/path_helper.dart` 4곳, `resource_update_service.dart:166`
- 리소스 다운로드 → 파일 저장 구조 전체.

### 2.3 발견 사항 — 다운로드한 이미지는 실제로 쓰이지 않는다

게임은 번들 에셋만 로드하고 있다 (`home_world.dart:34`, `timer_world.dart:22`,
`character_selectors.dart:66,82`, `character_setting.dart:48` 모두 `Flame.images.load(...)`).
`ResourceUpdateService.downloadImage`가 저장한 파일 경로를 렌더링에서 참조하는 코드가 없다.
즉 파일 저장 경로는 현재 미완성/죽은 경로에 가깝다.

### 2.4 웹에서 문제없는 의존성

`flame`, `just_audio`, `fl_chart`, `http`, `intl`, `flutter_dotenv`

### 2.5 아예 사용되지 않는 데드 의존성

`audioplayers`, `flame_tiled`, `dartz`, `equatable`, `flutter_web_auth_2`
(`flutter_web_auth_2`는 `login.dart:6`에서 주석 처리된 상태)

## 3. 앱인토스 플랫폼 제약 (조사 결과)

출처: [스토리지](https://developers-apps-in-toss.toss.im/documentation/common/file-storage/storage.md) ·
[파일 저장](https://developers-apps-in-toss.toss.im/documentation/common/file-storage/file.md) ·
[WebView 튜토리얼](https://developers-apps-in-toss.toss.im/ai-vibe-coding/tutorials/webview.md)

### 3.1 파일 저장 API는 리소스 캐시 용도로 쓸 수 없다

앱인토스가 제공하는 파일 API는 `saveBase64Data` 하나뿐이며, **사용자 기기(갤러리/다운로드)에
내려주는** 용도다. 앱이 저장한 것을 **다시 읽는 API가 없다**. 따라서 다운로드한 리소스를
보관했다가 재사용하는 용도로는 부적합하다.

→ 리소스는 **서버 URL 직접 로드**로 간다. 웹뷰에서는 브라우저 HTTP 캐시가 재요청을 커버한다.

### 3.2 IndexedDB는 iOS에서 7일 뒤 삭제된다 (설계 결정타)

앱인토스 문서에 명시: **"IndexedDB는 iOS에서 7일간 상호작용이 없으면 자동 삭제되므로
Cache API 사용을 권장"**.

이 제약이 결정적인 이유는 **웹에서 쓸 수 있는 Dart DB 패키지가 전부 IndexedDB 위에
올라가기 때문**이다 — `sembast_web`, `Hive`(웹), `Drift`(웹) 모두 해당한다.
그대로 채택하면 iOS 사용자가 일주일 앱을 켜지 않을 때 집중 세션 기록·발견한 행성·
캐릭터 선택이 전부 소실된다.

반면 앱인토스 `Storage` API는 네이티브 저장소로 브릿지되므로 이 정책의 영향을 받지 않고,
**저장 용량 제한도 없다** (앱 번들만 100MB 이하 제한).
단 **문자열만 저장 가능**하다. `AsyncStorage`는 사용 금지(화면이 백지가 되는 문제).

### 3.3 Flutter Web은 공식 지원 대상이 아니다 — 최대 리스크

- Unity WebGL은 공식 연동 가이드가 존재하나, **Flutter Web에 대한 공식 문서는 없다.**
- WebView SDK는 npm 패키지(`@apps-in-toss/web-framework`) + `granite.config.ts` +
  Vite 개발 서버를 전제로 문서화되어 있다.
- 배포는 자체 서버 URL이 아니라 **빌드 산출물 번들을 콘솔에 업로드**하는 방식이다.
  정적 산출물이면 가능성은 있으나 `flutter build web` 산출물이 통과할지는 **미검증**이다.
- SDK를 Flutter에서 호출하려면 `dart:js_interop`으로 감싸야 한다.

→ **이 리스크를 0단계 스파이크로 가장 먼저 해소한다 (섹션 5 참조).**

## 4. 설계

### 4.1 저장소 추상화 (2계층)

#### 계층 1 — `KeyValueStore` (문자열 키-값, 플랫폼별 어댑터)

```dart
// lib/core/storage/key_value_store.dart
abstract class KeyValueStore {
  Future<void> init();
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}
```

구현체:

| 어댑터 | 대상 환경 | 근거 |
|---|---|---|
| `TossStorageStore` | 앱인토스 웹뷰 | 앱인토스 `Storage` API를 `dart:js_interop`으로 래핑. 네이티브 저장소라 IndexedDB 7일 삭제 정책의 영향을 받지 않는다 |
| `SharedPreferencesStore` | 그 외 전부 (일반 브라우저, 안드로이드, iOS) | `shared_preferences`는 전 플랫폼을 지원하면서 `dart:io`를 요구하지 않는다. 이것 하나로 웹 fallback과 모바일 지원이 동시에 해결된다 |

런타임에 앱인토스 환경을 감지해 어댑터를 고르고, **감지 실패 시 `SharedPreferencesStore`로 fallback**한다.

플랫폼 분기는 **조건부 import 딱 한 곳**으로 격리한다:

```dart
// lib/core/storage/toss_storage_store.dart
export 'toss_storage_store_stub.dart'
    if (dart.library.js_interop) 'toss_storage_store_web.dart';
```

모바일 빌드에서는 stub이 `isAvailable => false`를 반환한다.
(`dart:js_interop`을 네이티브에서 직접 import하면 컴파일이 실패하므로 이 분기가 필요하다.)

#### 계층 2 — `DocumentStore<T>` (컬렉션, 순수 Dart)

```dart
// lib/core/storage/document_store.dart
class DocumentStore<T> {
  Future<void> load();                    // 백엔드 → 메모리 캐시 1회 로드
  Future<int> add(T item);                // 자동 증가 id 부여
  Future<void> put(int id, T item);
  Future<void> delete(int id);
  List<T> query({bool Function(T)? where, Comparator<T>? sort});
}
```

- 컬렉션 하나가 **키 하나에 JSON 배열 전체**로 직렬화되어 저장된다.
- 쓰기마다 컬렉션 전체를 재직렬화한다. 세션 수천 건 = 수백 KB 수준이라 이 앱 규모에서는
  문제없다. **다만 무한 성장하는 데이터에는 맞지 않는 구조**이며, 세션 수가 수만 건대로
  커지면 재설계가 필요하다.
- 순수 Dart이므로 in-memory `KeyValueStore`로 단위 테스트가 가능하다.

### 4.2 데이터 계층 교체

**교체 표면을 datasource 8개 안쪽으로 가둔다.** repository / viewmodel / view는 수정하지 않는다.

```dart
class FocusSessionDataSource {
  final DocumentStore<FocusSession> _store;

  Future<int> addFocusSession(FocusSession s) => _store.add(s);
  Future<List<FocusSession>> getFocusSessions() async =>
      _store.query(sort: (a, b) => a.date.compareTo(b.date));
}
```

- `getFocusSessionsByDateRange`의 시간대별 집계 로직(`focus_session_datasource.dart:63-98`)은
  **그대로 유지**하고, 앞단 Isar 쿼리만 `query(where:)`로 치환한다.
- 기존 쿼리는 전부 단순하다 (`put`, `findAll`+`sort`, 날짜 범위 필터, `getAll(ids)`).
  집계는 이미 Dart에서 수행하므로 SQL이 필요한 구석이 없다.

**Isar 컬렉션 모델 8개 변경** (`FocusSession`, `LatestActivity`, `Audio`, `Character`,
`SelectedCharacter`, `Discovery`, `Planet`, `ResourceVersion`.
`resource.dart`·`server_resource_info.dart`는 Isar 모델이 아니라 대상 아님):
- `import 'package:isar/isar.dart'` 제거
- `part '*.g.dart'`, `@Collection()` 제거
- `Id id = Isar.autoIncrement` → `int? id`
- 전 모델에 `toJson`/`fromJson` 추가 (`FocusSession`에는 이미 있음)
- **`.g.dart` 8개 삭제**, `isar_generator`·`build_runner` 제거 → **코드젠이 사라진다**

`core/db.dart`는 Isar 조립 대신 `DocumentStore` 조립으로 재작성하되,
`setUpDB()`가 datasource → repository를 초기화하는 기존 구조는 유지한다.
`setUpDB()`는 datasource를 만들기 전에 각 `DocumentStore.load()`를 await하여
메모리 캐시를 채운다 — 이후 `query()`가 동기 호출이 되는 전제다.

### 4.3 `dart:io` 제거

| 위치 | 조치 |
|---|---|
| `lib/main.dart:1,36-42,50-55` | `getLocalFile` + 파일 존재 확인 디버그 코드 삭제 (죽은 코드) |
| `lib/core/utils/path_helper.dart` | **파일 전체 삭제** — URL 로드 전환으로 존재 이유 소멸 |
| `lib/features/data/services/resource_update_service.dart:140-191` | `downloadImage`·`getImagePath` 삭제. 서버 조회 함수 3개(`fetchServerResourceInfo`, `fetchResourcesBetweenVersions`)만 유지 |
| `lib/core/db.dart:2,36` | `path_provider` import 및 사용 제거 |

결과: `dart:io` 참조 0개, `path_provider`·`path` 의존성 제거.

### 4.4 리소스 URL 직접 로드로 전환

`Flame.images.load()`는 **에셋 번들 전용**이라 원격 URL을 처리하지 못한다. 헬퍼를 둔다:

```dart
// lib/core/utils/sprite_loader.dart
Future<ui.Image> loadSprite(String pathOrUrl) async {
  if (!pathOrUrl.startsWith('http')) return Flame.images.load(pathOrUrl);
  if (Flame.images.containsKey(pathOrUrl)) return Flame.images.fromCache(pathOrUrl);
  final bytes = await http.readBytes(Uri.parse(pathOrUrl));
  final image = await decodeImageFromList(bytes);
  Flame.images.add(pathOrUrl, image);
  return image;
}
```

호출 지점 치환: `character_selectors.dart:66,82`, `character_setting.dart:48`,
`traveller.dart:10`(`setCharacter` 경로).

`resource_version_repository.dart:66-104`(`downloadResources`, `downloadPlanetImage`,
`downloadCharacterImage`)는 다운로드 대신 **URL을 Character/Planet 레코드에 저장**하는
로직으로 바뀐다.

> **의존 항목 (서버 작업)**: 리소스 서버가 `Access-Control-Allow-Origin` 헤더를 제공해야
> 브라우저에서 이미지 바이트를 받을 수 있다. Firebase Storage를 쓴다면 CORS 설정이 필요하다.
> 이 설정이 없으면 원격 스프라이트 로드가 전부 실패한다.

### 4.5 의존성 정리

**제거**: `isar`, `isar_flutter_libs`, `isar_generator`, `build_runner`, `path_provider`,
`path`, `audioplayers`, `flame_tiled`, `dartz`, `equatable`, `flutter_web_auth_2`

**추가**: `shared_preferences`

**유지**: `flame`, `just_audio`, `fl_chart`, `http`, `intl`, `flutter_dotenv`,
`flutter_localizations`, `wakelock_plus`

`wakelock_plus`는 웹을 지원하지만 앱인토스 웹뷰에서 Screen Wake Lock API가 동작할지
불확실하다. 현재 `main.dart:15-16`에서 `await`하고 있어 **실패 시 앱 초기화 전체가 죽는다.**
try/catch로 감싸 실패해도 앱이 뜨도록 한다.

`.env`는 웹 번들에 그대로 노출된다. 현재 `API_BASE_URL`뿐이라 당장 문제는 없으나,
**앞으로 비밀키를 넣어서는 안 된다.**

### 4.6 에러 처리

- `main.dart:56` — 현재 초기화 실패를 `print`만 하고 정상 화면을 띄운다. 저장소 초기화가
  실패하면 앱이 빈 데이터로 동작하므로, 실패를 사용자에게 알리는 경로를 추가한다.
- `TossStorageStore` 감지/초기화 실패 → `SharedPreferencesStore`로 fallback.
- 원격 스프라이트 로드 실패 → 기본 번들 에셋으로 fallback.

### 4.7 테스트

현재 테스트가 하나도 없다(`test/` 디렉토리 부재). 데이터 유실이 가장 아픈 지점이므로 여기에 건다.

- `DocumentStore` 단위 테스트 — in-memory `KeyValueStore` 구현으로. add/put/delete/query,
  id 자동 증가, 직렬화 라운드트립, 재로드 후 데이터 보존.
- datasource 단위 테스트 — 특히 `getFocusSessionsByDateRange`의 날짜 범위·집계 로직.

## 5. 실행 순서

### 0단계 — 앱인토스 호환성 스파이크 (선행 필수)

**기본 Flutter counter 앱을 웹 빌드해서 앱인토스 샌드박스에 올려본다.**

- 리팩토링을 한 줄도 하기 전에 수행 가능하다.
- 이것이 실패하면 **아래 1~5단계 전체가 무의미해진다.** Flutter Web이 공식 지원 대상이
  아니므로 실패 가능성이 실재한다.
- 실패 시: 설계 전면 재검토. (React 기반 재작성 또는 앱인토스 출품 자체 재고)

확인할 것: 번들 업로드 통과 여부, 샌드박스에서 렌더링 여부, CanvasKit 로딩 여부, 초기 로딩 시간.

### 1단계 — 웹 타겟 및 데드 코드 정리
`flutter create --platforms=web .`, 데드 의존성 5개 제거, `main.dart` 디버그 코드 삭제,
`wakelock_plus` try/catch 처리.

### 2단계 — 저장소 계층 신규 구현
`KeyValueStore` + `SharedPreferencesStore` + `DocumentStore` + 단위 테스트.
(`TossStorageStore`는 4단계로 미룬다 — 그 전까지는 fallback으로 동작한다.)

### 3단계 — Isar 제거
Isar 모델 8개 변환, `.g.dart` 8개 삭제, datasource 8개 치환, `core/db.dart` 재작성,
isar 계열 의존성 제거.
이 시점에도 `path_helper.dart`·`resource_update_service.dart`에 `dart:io`가 남아 있으므로
**아직 웹 빌드는 되지 않는다.**

### 4단계 — 리소스 URL 전환 및 `dart:io` 완전 제거
`path_helper.dart` 삭제, `resource_update_service`의 `downloadImage`·`getImagePath` 삭제,
`sprite_loader` 추가, `resource_version_repository` 수정, `path_provider`·`path` 의존성 제거.
서버 CORS 설정 확인.
**이 단계를 마치면 `dart:io` 참조가 0이 되어 `flutter build web`이 성공해야 한다 — 첫 번째
실질 마일스톤이다.**

### 5단계 — 앱인토스 통합
`@apps-in-toss/web-framework` 로드, `TossStorageStore` js_interop 구현,
`granite.config.ts` 작성, 환경 감지 로직, 샌드박스 최종 검증.

## 6. 열린 항목

- **앱인토스가 Flutter Web 번들을 수용하는가** — 0단계 스파이크로 확인. 최대 리스크.
- **리소스 서버 CORS 설정** — 서버(Cloud Functions / Storage) 쪽 작업 필요.
- **앱인토스 환경 감지 방법** — SDK가 제공하는 감지 수단을 5단계에서 확인.
- **웹뷰에서 `just_audio` 동작** — 웹 지원은 되나 앱인토스 웹뷰에서 자동재생 정책·
  사용자 제스처 요구사항이 어떻게 걸리는지 미확인.
- **모바일 빌드 유지 여부** — 설계상 계속 컴파일되지만 후순위라 검증 시점은 미정.
