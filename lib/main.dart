import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'features/game/catodo_game.dart';
import 'features/timer/presentation/widgets/timer_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GameWidget<CatodoGame>(
        game: CatodoGame(),
        overlayBuilderMap: {
          'timer': (context, game) => TimerOverlay(game: game),
        },
      ),
    );
  }
}
