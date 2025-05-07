import 'package:flutter/material.dart';
import 'package:catodo/features/dashboard/presentation/views/widgets/charts/focus_chart_per_date_unit.dart';
import 'package:catodo/features/dashboard/presentation/viewmodels/chart_state.dart';

class FocusChartContainer extends StatefulWidget {
  const FocusChartContainer({super.key});

  @override
  State<FocusChartContainer> createState() => _FocusChartContainerState();
}

class _FocusChartContainerState extends State<FocusChartContainer> {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => ChartManager.instance.movePrevious(),
                  icon: const Icon(Icons.chevron_left_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: const CircleBorder(),
                  ),
                  visualDensity: VisualDensity.compact,
                  iconSize: 20,
                  padding: const EdgeInsets.all(8),
                ),
                const SizedBox(width: 8),
                Text(ChartManager.instance.getFormattedDateRange()),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => ChartManager.instance.moveNext(),
                  icon: const Icon(Icons.chevron_right_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: const CircleBorder(),
                  ),
                  visualDensity: VisualDensity.compact,
                  iconSize: 20,
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
            DropdownButton<String>(
              value: state.currentDateUnit.name,
              items: const [
                DropdownMenuItem(
                  value: 'day',
                  child: Text('Day'),
                ),
                DropdownMenuItem(
                  value: 'week',
                  child: Text('Week'),
                ),
                DropdownMenuItem(
                  value: 'month',
                  child: Text('Month'),
                ),
                DropdownMenuItem(
                  value: 'year',
                  child: Text('Year'),
                ),
              ],
              onChanged: (String? newValue) {
                ChartManager.instance
                    .updateDateUnit(DateUnit.values.byName(newValue!));
              },
            ),
          ],
        ),
        const FocusChartPerDateUnit(),
      ],
    );
  }
}
