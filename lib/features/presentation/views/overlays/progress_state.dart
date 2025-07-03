import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/discovery_state.dart';
import 'package:catodo/features/presentation/viewmodels/characater_state.dart';

abstract class ProgressState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
    DiscoveryManager.instance.addListener(_handleDiscoveryStateChanged);
    CharacterManager.instance.addListener(_handleCharacterStateChanged);
    initData();
  }

  @override
  void dispose() {
    DiscoveryManager.instance.removeListener(_handleDiscoveryStateChanged);
    CharacterManager.instance.removeListener(_handleCharacterStateChanged);
    super.dispose();
  }

  void _handleCharacterStateChanged(CharacterState state) {
    setState(() {});
  }

  void _handleDiscoveryStateChanged(DiscoveryState state) {
    setState(() {});
  }

  initData() async {
    await DiscoveryManager.instance.initializeCurrentDiscovery();
    await CharacterManager.instance.initSelectedCharacter();
  }

  getProgress() {
    final totalSeconds = DiscoveryManager.instance.state.sessions
        .fold<int>(0, (sum, s) => sum + s.focusedTime);
    return calcProgress(totalSeconds.toDouble());
  }

  calcProgress(double progress) {
    return (progress / 36000).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context);
}
