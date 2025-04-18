import 'package:flutter/material.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/form_state.dart';
import 'package:catodo/features/overlays/presentation/viewmodels/timer_state.dart';

class FocusTimeInputWidget extends StatefulWidget {
  const FocusTimeInputWidget({super.key});

  @override
  State<FocusTimeInputWidget> createState() => _FocusTimeInputWidgetState();
}

class _FocusTimeInputWidgetState extends State<FocusTimeInputWidget> {
  @override
  void initState() {
    super.initState();
    FormManager.instance.addListener(_onFormStateChanged);
  }

  @override
  void dispose() {
    // 리스너 제거
    FormManager.instance.removeListener(_onFormStateChanged);
    super.dispose();
  }

  void _onFormStateChanged(FocusForm state) {}

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: FormManager.instance.state.duration ~/ 60,
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
            TimerManager.instance.updateGoalTime(value * 60);
            FormManager.instance.updateDuration(value * 60);
          });
        }
      },
    );
  }
}
