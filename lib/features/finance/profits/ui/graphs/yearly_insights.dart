import 'package:intl/intl.dart';

import '../../../../../exports.dart';
import '../../models/profits.dart';

class YearlyProfitsInsightsGraph extends StatelessWidget {
  final TooltipBehavior? tooltipBehavior;
  final String? tileText;
  final List<ProfitsInsights> chartData;
  const YearlyProfitsInsightsGraph(
      {super.key,
      required this.tooltipBehavior,
      this.tileText,
      required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        //title: ChartTitle(text: 'Age Demographics (Last 30 days)'),
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.yM(),
        ),
        primaryYAxis: const NumericAxis(anchorRangeToVisiblePoints: false),
        tooltipBehavior: tooltipBehavior,
        series: <CartesianSeries<ProfitsInsights, DateTime>>[
          LineSeries<ProfitsInsights, DateTime>(
            name: 'Sales',
            dataSource: chartData,
            xValueMapper: (ProfitsInsights data, _) =>
                getDate(data.group.substring(4, 18).toString()),
            yValueMapper: (ProfitsInsights data, _) => data.total,
          )
        ]);
  } //.substring(0, 10).toString()
}

DateTime getDate(String date) {
  final string = date;
  // String day = date.substring(8, 9);
  // String month = date.substring(4, 6);
  // String year = date.substring(11, 14);
  // String temp = day + month + year;
  // //final formatter = DateFormat('EEE MMM d yyyy HH:mm:ss');
  // final dateTime = DateTime.parse(temp);

  // final string = 'Jul 18 2022';
  final formatter = DateFormat('MMM dd yyy');
  final dateTime = formatter.parse(string);

  return dateTime;
}
