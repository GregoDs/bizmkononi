

import 'package:intl/intl.dart';

import '../../../../../exports.dart';
import '../../models/profits.dart';

class MonthlyProfitsInsightsGraph extends StatelessWidget {
  final TooltipBehavior? tooltipBehavior;
  final String? tileText;
  final List<ProfitsInsights> chartData;
  const MonthlyProfitsInsightsGraph(
      {super.key,
      required this.tooltipBehavior,
      this.tileText,
      required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.months,
          dateFormat: DateFormat.MMM(),
        ),
        primaryYAxis: const NumericAxis(anchorRangeToVisiblePoints: false),
        tooltipBehavior: tooltipBehavior,
        series: <CartesianSeries<ProfitsInsights, DateTime>>[
          LineSeries<ProfitsInsights, DateTime>(
            name: 'Sales',
            dataSource: chartData,
            xValueMapper: (ProfitsInsights data, _) => getDate(data.group.substring(4, 18).toString()),
            yValueMapper: (ProfitsInsights data, _) => data.total,
          )
        ]);
  } 
}

DateTime getDate(String date) {
  final string = date;
    final formatter = DateFormat('MMM dd yyy');
    final dateTime = formatter.parse(string);

  return dateTime;
}
