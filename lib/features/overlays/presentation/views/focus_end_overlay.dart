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
    return Stack(
      children: [
        // 배경 페이드아웃

        Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              int focussedTime = TimerManager.instance.state.focussedTime;
              FormManager.instance.save(focussedTime);
              TimerManager.instance.save();
            },
            child: Text('확인'),
          ),
        ),
      ],
    );
  }
}
