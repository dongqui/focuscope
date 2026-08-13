import { defineConfig } from '@apps-in-toss/web-framework/config';

// 앱인토스 미니앱 배포 설정 (`ait build` / `ait deploy`가 읽는다).
// appName은 앱인토스 콘솔에 등록한 이름과 일치해야 한다.
// webBundleDir은 `npm run build:web`(= flutter build web --release) 산출물 경로다.
export default defineConfig({
  appName: 'catodo',
  brand: {
    primaryColor: '#0175C2',
  },
  permissions: [],
  webView: {
    // 집중 타이머 도중 당겨서 새로고침되면 세션 화면이 리셋되므로 끈다.
    pullToRefreshEnabled: false,
    bounces: false,
  },
  webBundleDir: 'build/web',
});
