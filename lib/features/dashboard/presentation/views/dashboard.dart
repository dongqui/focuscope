import 'package:flutter/material.dart';
import 'package:catodo/features/dashboard/presentation/views/focus_chart_container.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        const FocusChartContainer(),
      ],
    );
  }
}
