import 'package:flutter/material.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/overlays/presentation/views/form_overlay/focus_activity_input_widget.dart';
import 'package:catodo/features/overlays/presentation/views/form_overlay/focus_time_input_widget.dart';

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

  void _handleDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 300) {
      // 아래로 스와이프 속도가 300 이상일 때
      _controller.reverse().then((_) {
        TimerManager.instance.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: GestureDetector(
        onVerticalDragEnd: _handleDragEnd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF0D1B2A).withValues(alpha: 0.9),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const FocusActivityInputWidget(),
                    const SizedBox(height: 32),
                    const FocusTimeInputWidget(),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () {
                        final currentFocus = FocusScope.of(context);
                        if (currentFocus.hasFocus) {
                          currentFocus.unfocus();
                          return;
                        }
                        TimerManager.instance.readyToFocus();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Color(0xFF3A86FF),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('시작하기'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
