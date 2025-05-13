import 'package:flutter/material.dart';
import 'package:catodo/features/dashboard/presentation/views/focus_chart_container.dart';
import 'package:catodo/features/dashboard/presentation/views/focus_summary_container.dart';
import 'package:catodo/features/dashboard/presentation/viewmodels/chart_state.dart';

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
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFF202735),
        padding: EdgeInsets.symmetric(horizontal: 16),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const FocusChartContainer(),
            const SizedBox(height: 20),
            const FocusSummaryContainer(),
          ],
        ),
      ),
    );
  }
}
