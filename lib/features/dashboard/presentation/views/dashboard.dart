import 'package:flutter/material.dart';
import 'package:catodo/features/dashboard/presentation/views/widgets/charts/year_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭의 수를 지정합니다.
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          TabBar(
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const YearChart(),
                    ],
                  ),
                ),
                Center(child: Text('두 번째 탭의 내용')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
