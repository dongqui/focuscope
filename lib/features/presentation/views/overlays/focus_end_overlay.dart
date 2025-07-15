import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/timer_state.dart';
import 'package:catodo/features/presentation/views/discovery_progress.dart';

import 'package:catodo/features/presentation/viewmodels/discovery_state.dart';
import 'package:catodo/features/presentation/views/overlays/progress_state.dart';
import 'package:catodo/features/presentation/viewmodels/characater_state.dart';
import 'package:catodo/features/presentation/viewmodels/form_state.dart';

class FocusEndOverlay extends StatefulWidget {
  const FocusEndOverlay({super.key});

  @override
  State<FocusEndOverlay> createState() => _FocusEndOverlayState();
}

class _FocusEndOverlayState extends ProgressState<FocusEndOverlay> {
  double? _addedProgress;

  @override
  void initState() {
    super.initState();
    saveData();
  }

  saveData() async {
    int focussedTime = TimerManager.instance.state.focussedTime;
    int sessionId = await FormManager.instance.save(focussedTime);

    await DiscoveryManager.instance.addSession(sessionId);
    setState(() {
      _addedProgress = focussedTime.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
        ),
        if (CharacterManager.instance.state.selectedCharacter != null &&
            DiscoveryManager.instance.state.planet != null)
          DiscoveryProgress(
            addedProgress:
                _addedProgress != null ? calcProgress(_addedProgress!) : null,
            progress: getProgress(),
            travelerImage:
                CharacterManager.instance.state.selectedCharacter!.idleSprite,
            planetImage: DiscoveryManager.instance.state.planet!.sprite,
          ),
        Positioned(
          bottom: 200,
          left: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: () {
              TimerManager.instance.save();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
              backgroundColor: Colors.white,
            ),
            child: const Text('계속', style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
