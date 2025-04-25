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

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FocusActivityInputWidget(),
                    const SizedBox(height: 20),
                    const Spacer(),
                    const FocusTimeInputWidget(),
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
          ),
        ],
      ),
    );
  }
}
