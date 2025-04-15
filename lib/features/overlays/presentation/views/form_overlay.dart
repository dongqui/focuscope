import 'package:flutter/material.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';

class FormOverlay extends StatefulWidget {
  const FormOverlay({super.key});

  @override
  State<FormOverlay> createState() => _FormOverlayState();
}

class _FormOverlayState extends State<FormOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  final _focusTextController = TextEditingController();
  int _selectedMinutes = 25;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '집중할 일을 입력하세요',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _focusTextController,
                    decoration: const InputDecoration(
                      hintText: '예: 수학 문제 풀기, 영어 단어 외우기',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '집중 시간',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: _selectedMinutes,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: [15, 25, 30, 45, 60].map((minutes) {
                      return DropdownMenuItem(
                        value: minutes,
                        child: Text('$minutes 분'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedMinutes = value;
                        });
                      }
                    },
                  ),
                  const Spacer(),
                  Hero(
                    tag: 'start_button',
                    child: ElevatedButton(
                      onPressed: TimerManager.instance.start,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('시작하기'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: TimerManager.instance.cancel,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('뒤로가기'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
