import 'package:flutter/material.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/dashboard/presentation/views/dashboard.dart';
import 'package:catodo/widgets/full_screen_overlay.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeOverlay extends StatefulWidget {
  const HomeOverlay({super.key});

  @override
  HomeOverlayState createState() => HomeOverlayState();
}

class HomeOverlayState extends State<HomeOverlay> {
  bool _isDashboardOpen = false;

  void _toggleDashboard() {
    setState(() {
      _isDashboardOpen = !_isDashboardOpen;
    });
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
        // 하단 버튼들
        // Positioned(
        //   bottom: 40,
        //   left: 0,
        //   right: 0,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       IconButton(
        //         onPressed: () {},
        //         icon: const Icon(
        //           Icons.settings,
        //           color: Colors.white,
        //           size: 32,
        //         ),
        //       ),
        //       const SizedBox(width: 40),
        //       IconButton(
        //         onPressed: _toggleDashboard,
        //         icon: const Icon(
        //           Icons.bar_chart,
        //           color: Colors.white,
        //           size: 32,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        if (_isDashboardOpen)
          FullScreenOverlay(
            onClose: _toggleDashboard,
            child: Dashboard(), // 대시보드 위젯을 여기에 추가하세요.
          ),
      ],
    );
  }
}
