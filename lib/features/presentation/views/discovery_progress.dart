import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/discovery_state.dart';
import 'dart:math';

import 'package:catodo/widgets/progressbar.dart';

class FocusItem {
  final double progress; // 0.0 ~ 1.0
  final String label;
  final double hours;
  final IconData icon;
  FocusItem({
    required this.progress,
    required this.label,
    required this.hours,
    required this.icon,
  });
}

class _ProgressMessage {
  final double threshold;
  final String message;
  const _ProgressMessage(this.threshold, this.message);
}

class DiscoveryProgress extends StatefulWidget {
  const DiscoveryProgress({super.key});

  @override
  State<DiscoveryProgress> createState() => _DiscoveryProgressState();
}

class _DiscoveryProgressState extends State<DiscoveryProgress> {
  final _discoveryManager = DiscoveryManager.instance;
  late DiscoveryState _discoveryState;

  final List<_ProgressMessage> progressMessages = [
    _ProgressMessage(0.0, "행성이 희미하게 감지됩니다..."),
    _ProgressMessage(0.2, "행성의 윤곽이 보이기 시작합니다."),
    _ProgressMessage(0.5, "행성이 점점 선명해집니다!"),
    _ProgressMessage(0.8, "거의 다 왔어요!"),
    _ProgressMessage(1.0, "행성을 발견했습니다!"),
  ];

  @override
  void initState() {
    super.initState();
    _discoveryState = _discoveryManager.state;
    _discoveryManager.addListener(_onDiscoveryStateChanged);
    _initDiscovery();
  }

  @override
  void dispose() {
    _discoveryManager.removeListener(_onDiscoveryStateChanged);
    super.dispose();
  }

  void _onDiscoveryStateChanged(DiscoveryState state) {
    setState(() {
      _discoveryState = state;
    });
  }

  Future<void> _initDiscovery() async {
    await _discoveryManager.initializeCurrentDiscovery();
  }

  double get _progress {
    // 세션의 focusedTime 총합을 10시간(36000초) 만점으로 0~1로 환산
    final totalSeconds =
        _discoveryState.sessions.fold<int>(0, (sum, s) => sum + s.focusedTime);
    return (totalSeconds / 36000).clamp(0.0, 1.0);
  }

  String getProgressMessage(double progress) {
    for (int i = progressMessages.length - 1; i >= 0; i--) {
      if (progress >= progressMessages[i].threshold) {
        return progressMessages[i].message;
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final double progress = 0.72;
    final double planetSize = 256;
    // minAlpha 제거, bottomAlpha는 0.0~1.0로만 동작
    final double bottomAlpha = (1.0 - max(0.1, progress)).clamp(0.0, 1.0);
    final String progressMessage = getProgressMessage(progress);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: planetSize,
          height: planetSize,
          child: Stack(
            children: [
              // 행성 이미지 (아래)
              Image.asset(
                'assets/images/planet_1.png',
                width: planetSize,
                height: planetSize,
                fit: BoxFit.cover,
              ),
              // 전체 그라데이션 덮개 (위->아래, 검정->반투명)
              Container(
                width: planetSize,
                height: planetSize,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Color.fromRGBO(0, 0, 0, bottomAlpha),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 왼쪽: 여행자 이미지
            Image.asset(
              'assets/images/astronaut_idle.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 16),
            // 가운데: 프로그레스바와 텍스트
            Column(
              children: [
                Text(''),
                CustomPaint(
                  size: const Size(256, 20),
                  painter: ProgressBarPainter(progress: progress),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(progress < 0.1 ? 2 : 1)}%',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // 오른쪽: 행성 이미지
            Image.asset(
              'assets/images/planet.png',
              width: 32,
              height: 32,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          progressMessage,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black.withOpacity(0.7),
                offset: Offset(1, 1),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
