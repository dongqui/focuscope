import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/chart_state.dart';

class FocusSummaryContainer extends StatefulWidget {
  const FocusSummaryContainer({super.key});

  @override
  State<FocusSummaryContainer> createState() => _FocusSummaryContainerState();
}

class _FocusSummaryContainerState extends State<FocusSummaryContainer> {
  final state = ChartManager.instance.state;

  void _handleChangeState(ChartState state) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ChartManager.instance.addListener(_handleChangeState);
  }

  @override
  void dispose() {
    ChartManager.instance.removeListener(_handleChangeState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF171F2A),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(36),
          child: Center(
            child: Text(
              'Total Time\n${_calculateTotalTime()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: Color(0xFF171F2A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'Sessions\n${_calculateSessionCount()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _calculateTotalTime() {
    int totalSeconds = 0;
    for (var session in state.focusSessions) {
      for (var (_, duration) in session) {
        totalSeconds += duration;
      }
    }

    if (totalSeconds < 60) {
      return '${totalSeconds}s';
    } else if (totalSeconds < 3600) {
      return '${(totalSeconds / 60).round()}m';
    } else {
      int hours = (totalSeconds / 3600).floor();
      int minutes = ((totalSeconds % 3600) / 60).round();
      return '${hours}h${minutes}m';
    }
  }

  String _calculateSessionCount() {
    return state.focusSessions.length.toString();
  }
}
