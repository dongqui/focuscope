import 'package:flutter/material.dart';
import '../../viewmodels/timer_state.dart';

class TimerOverlay extends StatefulWidget {
  const TimerOverlay({super.key});

  @override
  State<TimerOverlay> createState() => _TimerOverlayState();
}

class _TimerOverlayState extends State<TimerOverlay> {
  late TimerState _timerState;
  final _timerManager = TimerManager.instance;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 타이머 디스플레이
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                _formatTime(_timerState.focussedTime),
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                getStatusText(_timerState.status),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // 타이머 컨트롤
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _timerManager.start,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('시작'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _timerManager.pause,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('일시정지'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _timerManager.finish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('리셋'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _timerManager.finish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('음악'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getStatusText(TimerStatus status) {
    switch (status) {
      case TimerStatus.idle:
        return '준비';
      case TimerStatus.running:
        return '집중 중';
      case TimerStatus.paused:
        return '일시정지';
      case TimerStatus.end:
        return '완료!';
      default:
        return '';
    }
  }
}
