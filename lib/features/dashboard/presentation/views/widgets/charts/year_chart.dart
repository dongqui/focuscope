import 'package:flutter/material.dart';
import 'package:catodo/features/dashboard/presentation/views/widgets/charts/base_chart.dart';

class YearChart extends StatelessWidget {
  const YearChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseChart(dataList: [
      [],
      [('work', 320), ('study', 230), ('social', 120), ('etc', 100)],
      [('work', 320), ('study', 124), ('social', 120), ('etc', 100)],
      [('work', 451), ('study', 230), ('social', 120), ('etc', 52)],
      [('work', 320), ('study', 23), ('social', 123), ('etc', 100)],
      [('work', 432), ('study', 230), ('social', 120), ('etc', 100)],
      [('work', 320), ('study', 230), ('social', 245), ('etc', 100)],
      [('work', 320), ('study', 230), ('social', 333), ('etc', 62)],
      [('work', 221), ('study', 45), ('social', 120), ('etc', 100)],
      [('work', 320), ('study', 230), ('social', 120), ('etc', 72)],
      [],
      [],
      [('work', 320), ('study', 230), ('social', 120), ('etc', 72)],
      [('work', 320), ('study', 230), ('social', 120), ('etc', 72)],
      [('work', 320), ('study', 230), ('social', 120), ('etc', 72)],
      [('work', 320), ('study', 230), ('social', 120), ('etc', 72)],
    ], labels: [
      'JAN',
      'FAB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
      'Test',
      'Test',
      'Test',
      'Test',
    ]);
  }
}
