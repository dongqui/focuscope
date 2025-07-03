import 'package:flutter/material.dart';

import 'package:catodo/features/presentation/views/discovery_progress.dart';
import 'package:catodo/features/presentation/views/focus_form/form.dart';
import 'package:catodo/features/presentation/viewmodels/discovery_state.dart';
import 'package:catodo/features/presentation/viewmodels/characater_state.dart';
import 'package:catodo/features/presentation/views/overlays/progress_state.dart';

class FocusFormOverlay extends StatefulWidget {
  const FocusFormOverlay({super.key});

  @override
  State<FocusFormOverlay> createState() => _FocusFormOverlayState();
}

class _FocusFormOverlayState extends ProgressState<FocusFormOverlay> {
  @override
  Widget build(BuildContext context) {
    const double formHeight = 330;
    const double gap = 16;
    return Stack(
      children: [
        Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
        ),
        if (CharacterManager.instance.state.selectedCharacter != null &&
            DiscoveryManager.instance.state.planet != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: formHeight + gap,
            child: DiscoveryProgress(
              progress: getProgress(),
              travelerImage:
                  CharacterManager.instance.state.selectedCharacter!.idleSprite,
              planetImage: DiscoveryManager.instance.state.planet!.image,
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SizedBox(
            height: formHeight,
            child: FocusForm(),
          ),
        ),
      ],
    );
  }
}
