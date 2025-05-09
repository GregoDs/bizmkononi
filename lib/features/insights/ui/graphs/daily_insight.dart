import 'package:intl/intl.dart';

import '../../../../exports.dart';
import '../../models/insights.dart';

class DayInsightsGraph extends StatelessWidget {
  final TooltipBehavior? tooltipBehavior;
  final String tileText;
  final List<Insights> chartData;

  const DayInsightsGraph({
    super.key,
    required this.tooltipBehavior,
    required this.tileText,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Daily Sales (Last 7 days)'),
      legend: const Legend(isVisible: true, position: LegendPosition.top),
      tooltipBehavior: tooltipBehavior,
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.days,
        dateFormat: DateFormat.MMMd(),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: tileText,
        ),
      ),
      series: <CartesianSeries<Insights, DateTime>>[
        ColumnSeries<Insights, DateTime>(
          name: 'sales',
          dataSource: chartData,
          xValueMapper: (Insights data, _) => data.group,
          yValueMapper: (Insights data, _) => double.parse(data.total),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          enableTooltip: true,
          width: 0.2,
          color: ColorName.blue200,
        ),
      ],
    );
  }
}


