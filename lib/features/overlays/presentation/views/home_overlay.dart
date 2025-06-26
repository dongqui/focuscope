import 'package:flutter/material.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/dashboard/presentation/views/dashboard.dart';
import 'package:catodo/widgets/full_screen_overlay.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:catodo/features/characters/presentation/views/character_selectors.dart';
import 'dart:ui';
import 'package:catodo/features/characters/presentation/viewmodels/characater_state.dart';

class HomeOverlay extends StatefulWidget {
  const HomeOverlay({super.key});

  @override
  HomeOverlayState createState() => HomeOverlayState();
}

class HomeOverlayState extends State<HomeOverlay>
    with SingleTickerProviderStateMixin {
  bool _isDashboardOpen = false;
  bool _isCharacterSelectorsOpen = false;
  late final AnimationController _settingsAnimController;
  late final Animation<double> _settingsGlowAnim;
  late final Animation<double> _settingsRotateAnim;
  bool _settingsPressed = false;

  @override
  void initState() {
    super.initState();
    _settingsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _settingsGlowAnim = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _settingsAnimController, curve: Curves.easeOut),
    );
    _settingsRotateAnim = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _settingsAnimController, curve: Curves.easeOut),
    );

    CharacterManager.instance.initSelectedCharacter();
  }

  @override
  void dispose() {
    _settingsAnimController.dispose();
    super.dispose();
  }

  void _toggleDashboard() {
    setState(() {
      _isDashboardOpen = !_isDashboardOpen;
    });
  }

  void _toggleCharacterSelectors() {
    setState(() {
      _isCharacterSelectorsOpen = !_isCharacterSelectorsOpen;
    });
  }

  void _onSettingsTap() async {
    setState(() => _settingsPressed = true);
    await _settingsAnimController.forward();
    await Future.delayed(const Duration(milliseconds: 120));
    await _settingsAnimController.reverse();
    setState(() => _settingsPressed = false);

    _toggleCharacterSelectors();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned.fill(
        //   child: Image.asset(
        //     'assets/images/home_image.png',
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // Positioned(
        //   top: 200,
        //   left: 0,
        //   right: 0,
        //   child: Text(
        //     AppLocalizations.of(context)!.home_message,
        //     textAlign: TextAlign.center,
        //     style: const TextStyle(
        //       fontSize: 22,
        //       fontWeight: FontWeight.w500,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),

        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: ElevatedButton(
              onPressed: () => TimerManager.instance.readyToFocus(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.start,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // 설정 버튼 (오른쪽 상단)
        Positioned(
          top: 20,
          right: 20,
          child: AnimatedBuilder(
            animation: _settingsAnimController,
            builder: (context, child) {
              return GestureDetector(
                onTap: _onSettingsTap,
                child: Transform.rotate(
                  angle: _settingsRotateAnim.value * 3.1416 * 2,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      boxShadow: [
                        if (_settingsPressed ||
                            _settingsAnimController.value > 0)
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: _settingsGlowAnim.value,
                            spreadRadius: 1,
                          ),
                      ],
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Center(
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isDashboardOpen)
          FullScreenOverlay(
            onClose: _toggleDashboard,
            child: (context, onClose) => Dashboard(), // 대시보드 위젯을 여기에 추가하세요.
          ),
        if (_isCharacterSelectorsOpen)
          FullScreenOverlay(
            onClose: _toggleCharacterSelectors,
            backgroundColor: Colors.black,
            child: (context, onClose) => CharacterSelectors(onClose: onClose!),
          ),
      ],
    );
  }
}
