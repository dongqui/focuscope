import 'package:flutter/material.dart';
import 'package:catodo/features/dashboard/presentation/views/widgets/charts/base_chart.dart';
import 'package:catodo/features/dashboard/presentation/viewmodels/chart_state.dart';

class FocusChartPerDateUnit extends StatefulWidget {
  const FocusChartPerDateUnit({super.key});

  @override
  State<FocusChartPerDateUnit> createState() => _FocusChartPerDateUnitState();
}

class _FocusChartPerDateUnitState extends State<FocusChartPerDateUnit> {
  final state = ChartManager.instance.state;

  @override
  void initState() {
    super.initState();
    ChartManager.instance.addListener(handleChartStateChange);
  }

  @override
  void dispose() {
    ChartManager.instance.removeListener(handleChartStateChange);
    super.dispose();
  }

  handleChartStateChange(ChartState state) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseChart(dataList: state.focusSessions, labels: getLabels());
  }

  List<String> getLabels() {
    if (state.currentDateUnit == DateUnit.day) {
      return List.generate(24, (index) => index.toString());
    } else if (state.currentDateUnit == DateUnit.week) {
      return ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    } else if (state.currentDateUnit == DateUnit.month) {
      return List.generate(31, (index) => (index + 1).toString());
    } else if (state.currentDateUnit == DateUnit.year) {
      return [
        'JAN',
        'FEB',
        'MAR',
        'APR',
        'MAY',
        'JUN',
        'JUL',
        'AUG',
        'SEP',
        'OCT',
        'NOV',
        'DEC'
      ];
    }
    return [];
  }
}
