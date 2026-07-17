# catodo

우주 탐험 게임 레이어를 결합한 Flutter 집중(포커스) 타이머 앱. 집중 세션을 진행하면 우주선 여행자가
우주를 날아다니며 캐릭터와 행성("discovery")을 해금한다. 모든 앱 데이터는 기기 내 Isar DB에 저장되는
로컬 우선(local-first) 구조다.

## 기술 스택

| 구분 | 사용 기술 |
| --- | --- |
| 프레임워크 | Flutter (Dart SDK ^3.6.0) |
| 게임 엔진 | Flame, flame_tiled |
| 로컬 DB | Isar (isar_generator / build_runner 코드 생성) |
| 상태 관리 | 직접 구현한 싱글톤 매니저 + `Observer` 패턴 (외부 패키지 미사용) |
| 네트워크 | http (Cloud Functions REST API) |
| 백엔드 | Firebase Cloud Functions (TypeScript, Node 22) — `functions/` |
| 오디오 | audioplayers, just_audio |
| 차트 | fl_chart |
| 국제화 | flutter_localizations, intl, ARB (`lib/l10n/`) |
| 기타 | path_provider, wakelock_plus, flutter_dotenv, dartz, equatable |

> Firebase 클라이언트 SDK는 현재 비활성화(주석 처리)되어 있으며, 백엔드는 순수 HTTP Cloud Functions API를 사용한다.

## 프로젝트 구조

```
lib/
├─ main.dart               # 앱 진입점 (초기화 → SplashScreen → MainScreen)
├─ core/                   # DB 설정(db.dart), 시작 시드(init_db.dart), Observer, 유틸
├─ constants/, extensions/, widgets/   # 공용 상수 / 확장 / 위젯
└─ features/
   ├─ data/                # 데이터 계층
   │  ├─ models/           # Isar @collection 모델 + 생성된 *.g.dart
   │  ├─ datasources/      # Isar CRUD 래퍼
   │  ├─ repositories/     # 비즈니스 로직 (2단계 싱글톤)
   │  └─ services/         # HTTP 등 외부 연동
   ├─ presentation/        # 프레젠테이션 계층
   │  ├─ viewmodels/       # 상태(State) + 매니저(Manager) 싱글톤
   │  └─ views/            # 위젯 & 게임 오버레이
   └─ game/                # Flame 게임
      ├─ game_root.dart    # FlameGame 루트 (Home/Timer World 전환)
      ├─ components/       # 여행자, 행성, 별, 월드 등
      └─ events/           # 이벤트 버스 + 매니저

functions/                 # Firebase Cloud Functions 백엔드 (TypeScript)
lib/l10n/                  # 다국어 ARB (app_en.arb, app_ko.arb)
```

### 아키텍처 요약

- **상태 관리**: 도메인마다 불변 `XxxState`(+`copyWith`)와 싱글톤 `XxxManager`를 두고, `core/observer.dart`의
  `Observer<T>`를 기반으로 리스너에 변경을 통지한다. 게임 전반의 반응은 `GameEventBus`(브로드캐스트 스트림)와
  `GameEventManager`를 통해 연결된다.
- **게임 ↔ UI**: `MainScreen`이 단일 `GameWidget`을 띄우고, `GameOverlay` enum으로 Flutter 오버레이를 전환한다.
  게임과 UI는 매니저 싱글톤을 통해 통신한다.
- **리소스 버전 관리**: 앱은 기본 에셋을 내장하고, 추가 캐릭터/행성은 서버 버전 비교 후 필요 시 다운로드한다.

## 개발

```bash
flutter pub get                                            # 의존성 설치
dart run build_runner build --delete-conflicting-outputs   # Isar 모델 코드 생성
flutter run                                                # 실행
flutter analyze                                            # 정적 분석
flutter test                                               # 테스트

cd functions && npm run build      # Cloud Functions 빌드
cd functions && npm run deploy     # Cloud Functions 배포
```

> Isar `@collection` 모델을 수정하면 반드시 `build_runner`를 다시 실행한다.
> 실행에는 `.env`(git 무시됨, `API_BASE_URL`)가 필요하다.
