{{flutter_js}}
{{flutter_build_config}}

// 앱인토스는 번들 업로드 배포라 외부 CDN(gstatic) 접근이 CSP/네트워크 정책으로
// 막힐 수 있다. CanvasKit을 번들 내부 경로로 고정한다.
// <base href> 기준 상대 경로여야 한다 — 하위 경로 서빙 시 절대 경로는 깨진다.
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: 'canvaskit/',
  },
});
