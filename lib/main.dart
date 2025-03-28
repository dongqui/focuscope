import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'features/game/game_root.dart';
import 'features/timer/presentation/widgets/timer_overlay.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

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
          game: GameRoot(),
          overlayBuilderMap: {
            'timer': (context, game) => const TimerOverlay(),
          },
        ),
      ),
    );
  }
}
