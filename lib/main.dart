import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:catodo/core/init_db.dart';
import 'features/presentation/views/splash_screen.dart';
import 'features/presentation/views/main_screen.dart';
import 'features/presentation/viewmodels/resource_version_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WakelockPlus.enable();
  await WakelockPlus.toggle(enable: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await initDB();
    await initVersion();
    await versionCheck();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Catodo',
      // TODO: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#localizing-for-ios-updating-the-ios-app-bundle
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF3A86FF)), // 보라색에서 파란색으로 변경
        useMaterial3: true,
      ),
      home: _isInitialized ? MainScreen() : SplashScreen(),
    );
  }
}

Future<void> initVersion() async {
  if (ResourceVersionManager.instance.state.version == null) {
    await ResourceVersionManager.instance.initVersion();
  }
}

Future<void> versionCheck() async {
  final needsUpdate =
      await ResourceVersionManager.instance.checkVersionUpdate();

  if (needsUpdate) {
    // 버전 업데이트가 필요할 때 dialog 표시
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('업데이트 필요'),
          content: Text('새로운 리소스가 있습니다. 리소스를 다운로드 받으시겠어요?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('나중에'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ResourceVersionManager.instance.updateResources();
                // 업데이트 로직 구현
              },
              child: Text('업데이트'),
            ),
          ],
        );
      },
    );
  }
}
