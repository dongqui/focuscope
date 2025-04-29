import 'package:flutter/material.dart';
import '../../viewmodels/timer_state.dart';
import 'package:catodo/features/audio/presentation/views/audio_box.dart';

class TimerOverlay extends StatefulWidget {
  const TimerOverlay({super.key});

  @override
  State<TimerOverlay> createState() => _TimerOverlayState();
}

class _TimerOverlayState extends State<TimerOverlay> {
  late TimerState _timerState;
  final _timerManager = TimerManager.instance;

  final GlobalKey audioButtonKey = GlobalKey();
  bool _isAudioBoxVisible = false;
  double audioBoxPositionY = 100.0; // 버튼의 bottom y좌표 저장

  @override
  void initState() {
    super.initState();
    _timerState = _timerManager.state;
    _timerManager.addListener(_handleTimerStateChanged);
  }

  @override
  void dispose() {
    _timerManager.removeListener(_handleTimerStateChanged);
    super.dispose();
  }

  void _handleTimerStateChanged(TimerState state) {
    setState(() {
      _timerState = state;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _toggleAudioBox() {
    final RenderBox renderBox =
        audioButtonKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    setState(() {
      _isAudioBoxVisible = !_isAudioBoxVisible;
      audioBoxPositionY = position.dy + size.height; // 버튼의 bottom y좌표
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          const SizedBox(height: 40),
          // 타이머 디스플레이
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 음악 버튼
              IconButton(
                key: audioButtonKey,
                onPressed: _toggleAudioBox,
                icon: Icon(
                  Icons.music_note,
                ),
              ),
              // 타이머 텍스트
              Text(
                _formatTime(_timerState.focussedTime),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // 빈 공간
              SizedBox(width: 48), // 음악 버튼과 같은 크기의 빈 공간
            ],
          ),
          // 타이머 컨트롤
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _timerState.status == TimerStatus.running
                        ? _timerManager.pause
                        : _timerManager.start,
                    icon: Icon(
                      _timerState.status == TimerStatus.running
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: _timerManager.finish,
                    icon: Icon(
                      Icons.refresh,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      Positioned(
        top: audioBoxPositionY,
        width: 200,
        height: 200,
        child: Offstage(
          offstage: !_isAudioBoxVisible,
          child: AudioBox(),
        ),
      ),
    ]);
  }
}
