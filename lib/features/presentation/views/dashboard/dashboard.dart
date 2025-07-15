import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/views/dashboard/focus_chart_container.dart';
import 'package:catodo/features/presentation/views/dashboard/focus_summary_container.dart';
import 'package:catodo/features/presentation/viewmodels/chart_state.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    ChartManager.instance.getFocusSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FocusChartContainer(),
        const SizedBox(height: 20),
        const FocusSummaryContainer(),
      ],
    );
  }
}
