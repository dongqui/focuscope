import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'features/game/game_root.dart';
import 'features/overlays/presentation/views/timer_overlay/timer_overlay.dart';
import 'features/overlays/presentation/views/home_overlay.dart';
import 'features/overlays/presentation/views/form_overlay/form_overlay.dart';
import 'package:catodo/features/game/game_overlay_manager.dart';
import 'package:catodo/core/init.dart';
import 'features/overlays/presentation/views/focus_end_overlay.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/overlays/presentation/views/ready_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WakelockPlus.enable();
  await WakelockPlus.toggle(enable: true);
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final game = GameRoot();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catodo',
      // TODO: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#localizing-for-ios-updating-the-ios-app-bundle
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF3A86FF)), // 보라색에서 파란색으로 변경
        useMaterial3: true,
      ),
      home: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          return;
        },
        child: Scaffold(
          body: SafeArea(
            top: false,
            child: GameWidget(
              game: game,
              overlayBuilderMap: {
                GameOverlay.home.name: (context, game) => const HomeOverlay(),
                GameOverlay.timer.name: (context, game) => const TimerOverlay(),
                GameOverlay.form.name: (context, game) => const FormOverlay(),
                GameOverlay.focusEnd.name: (context, game) =>
                    const FocusEndOverlay(),
                GameOverlay.ready.name: (context, game) => const ReadyOverlay(),
              },
              initialActiveOverlays: [GameOverlay.home.name],
            ),
          ),
        ),
      ),
    );
  }
}
