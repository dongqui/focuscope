import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'features/game/game_root.dart';
import 'features/overlays/presentation/views/timer_overlay.dart';
import 'features/overlays/presentation/views/home_overlay.dart';
import 'package:catodo/features/game/game_overlay_manager.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  // 게임 인스턴스를 한 번만 생성
  final _game = GameRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Catodo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: RiverpodAwareGameWidget(
          key: GlobalKey<RiverpodAwareGameWidgetState<GameRoot>>(),
          game: _game, // 미리 생성한 인스턴스 사용
          overlayBuilderMap: {
            GameOverlay.home.name: (context, game) => const HomeOverlay(),
            GameOverlay.timer.name: (context, game) => const TimerOverlay(),
          },
          initialActiveOverlays: ['home'],
        ),
      ),
    );
  }
}
