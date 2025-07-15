import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/presentation/views/dashboard/dashboard.dart';
import 'package:catodo/widgets/full_screen_overlay.dart';
import 'package:catodo/features/presentation/views/character_selectors.dart';
import 'package:catodo/features/presentation/viewmodels/characater_state.dart';
import 'package:catodo/features/presentation/views/overlays/settings/settings.dart';

class HomeOverlay extends StatefulWidget {
  const HomeOverlay({super.key});

  @override
  HomeOverlayState createState() => HomeOverlayState();
}

class HomeOverlayState extends State<HomeOverlay>
    with SingleTickerProviderStateMixin {
  bool _isDashboardOpen = false;
  bool _isCharacterSelectorsOpen = false;

  @override
  void initState() {
    super.initState();
    // 애니메이션 관련 초기화 제거
    // CharacterManager.instance.initSelectedCharacter();
    CharacterManager.instance.initSelectedCharacter();
  }

  @override
  void dispose() {
    // 애니메이션 컨트롤러 dispose 제거
    // _settingsAnimController.dispose();
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
    // 애니메이션 효과 제거, 바로 캐릭터 선택창 토글
    _toggleCharacterSelectors();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _ShuttleWaveButton(
            onTap: () => TimerManager.instance.setFocus(),
          ),
        ),
        // 설정 버튼 (오른쪽 상단)
        Positioned(
          top: 20,
          right: 20,
          child: GestureDetector(
            onTap: _onSettingsTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: Center(
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        // if (_isDashboardOpen)
        //   FullScreenOverlay(
        //     onClose: _toggleDashboard,
        //     child: (context, onClose) => Dashboard(), // 대시보드 위젯을 여기에 추가하세요.
        //   ),
        if (!_isCharacterSelectorsOpen)
          FullScreenOverlay(
            onClose: _toggleCharacterSelectors,
            backgroundColor: Colors.black,
            child: (context, onClose) => SettingsOverlay(),
          ),
      ],
    );
  }
}

// 파일 하단에 커스텀 버튼 위젯 추가
class _ShuttleWaveButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ShuttleWaveButton({required this.onTap});

  @override
  State<_ShuttleWaveButton> createState() => _ShuttleWaveButtonState();
}

class _ShuttleWaveButtonState extends State<_ShuttleWaveButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Halo/Wave 효과 (3겹)
            ...List.generate(3, (i) {
              final delay = i * 0.33;
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final progress = (_controller.value + delay) % 1.0;
                  final size = 60.0 + progress * 40.0;
                  final opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.35;
                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[600]!.withOpacity(opacity),
                    ),
                  );
                },
              );
            }),
            // 중앙 버튼 (shuttle 이미지)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.grey[700],
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey[700]!.withOpacity(0.25),
                //     blurRadius: 16,
                //     spreadRadius: 2,
                //   ),
                // ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/icons/shuttle.png',
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
