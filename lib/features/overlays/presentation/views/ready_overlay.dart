import 'package:flutter/material.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'dart:async';

class ReadyOverlay extends StatefulWidget {
  const ReadyOverlay({super.key});

  @override
  State<ReadyOverlay> createState() => _ReadyOverlayState();
}

class _ReadyOverlayState extends State<ReadyOverlay>
    with TickerProviderStateMixin {
  final String message = '곧 집중이 시작돼요!\n마음의 준비를 해볼까요?';
  late List<double> charOpacities;
  double overlayOpacity = 1.0;
  bool animationDone = false;

  @override
  void initState() {
    super.initState();
    charOpacities = List.filled(message.length, 1.0);
    _startCharFadeOut();
  }

  void _startCharFadeOut() async {
    // 2초 동안 글자 모두 보이기
    await Future.delayed(const Duration(milliseconds: 2000));
    // 2초 동안 글자 순차적으로 사라지기
    const fadeOutDuration = 2000;
    final perCharDelay = (fadeOutDuration / message.length).floor();
    for (int i = 0; i < message.length; i++) {
      await Future.delayed(Duration(milliseconds: perCharDelay));
      setState(() {
        charOpacities[i] = 0.0;
      });
    }
    // 모든 글자가 사라진 후 오버레이 전체 페이드아웃
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      overlayOpacity = 0.0;
    });
    // 오버레이가 완전히 사라진 후 타이머 시작
    await Future.delayed(const Duration(milliseconds: 400));
    if (!animationDone) {
      animationDone = true;
      startFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 페이드아웃
        AnimatedOpacity(
          opacity: overlayOpacity,
          duration: const Duration(milliseconds: 400),
          child: Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // 글자 애니메이션 (항상 불투명한 배경 위에)
        IgnorePointer(
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(message.length, (i) {
                final char = message[i] == '\n' ? '\n' : message[i];
                if (char == '\n') {
                  return const SizedBox(width: double.infinity, height: 16);
                }
                return AnimatedOpacity(
                  opacity: charOpacities[i],
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    char,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  void startFocus() {
    TimerManager.instance.start();
  }
}
