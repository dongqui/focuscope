import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/presentation/viewmodels/form_state.dart';
import 'package:catodo/features/presentation/views/discovery_progress.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DiscoveryProgress(),
              ElevatedButton(
                onPressed: () {
                  int focussedTime = TimerManager.instance.state.focussedTime;
                  FormManager.instance.save(focussedTime);
                  TimerManager.instance.save();
                },
                child: Text('확인'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
