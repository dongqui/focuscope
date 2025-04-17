import 'package:flutter/material.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/form_state.dart';

class FocusEndOverlay extends StatefulWidget {
  const FocusEndOverlay({super.key});

  @override
  State<FocusEndOverlay> createState() => _FocusEndOverlayState();
}

class _FocusEndOverlayState extends State<FocusEndOverlay> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          FormManager.instance.save(TimerManager.instance.state.focussedTime);
          TimerManager.instance.save();
        },
        child: Text('확인'),
      ),
    );
  }
}
