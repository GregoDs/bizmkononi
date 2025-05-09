import 'package:biz_mkononi/exports.dart';
import 'package:intl/intl.dart';

import '../../models/insights.dart';

// class MonthInsightsGraph extends StatelessWidget {
//   final TooltipBehavior? tooltipBehavior;
//   final String tileText;
//   final List<Insights> chartData;
//   const MonthInsightsGraph({
//     super.key,
//     required this.tooltipBehavior,
//     required this.tileText,
//     required this.chartData
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SfCartesianChart(
//       title: const ChartTitle(text: 'Monthly Sales (Last 7 Months)'),
//       legend: const Legend(isVisible: true, position: LegendPosition.top),
//       tooltipBehavior: tooltipBehavior,
//       primaryXAxis: DateTimeAxis(
//         intervalType: DateTimeIntervalType.months,
//         dateFormat: DateFormat.MMMd(),
//       ),
//       primaryYAxis: NumericAxis(
//           title: AxisTitle(
//         text: tileText,
//       )),
//       series: <CartesianSeries<Insights, DateTime>>[
//         ColumnSeries<Insights, DateTime>(
//             name: 'sales',
//             dataSource: chartData,
//             xValueMapper: (Insights data, _) => data.group,
//             yValueMapper: (Insights data, _) => double.parse(data.total),
//             dataLabelSettings:const DataLabelSettings(isVisible: true),
//             enableTooltip: true,
//             width: 0.5,
//             color: ColorName.blue200,
//         )
//       ],
//     );
//   }
// }
class MonthInsightsGraph extends StatelessWidget {
  final TooltipBehavior? tooltipBehavior;
  final String tileText;
  final List<Insights> chartData;
  
  const MonthInsightsGraph({
    super.key,
    required this.tooltipBehavior,
    required this.tileText,
    required this.chartData
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: SfCartesianChart(
        title: const ChartTitle(text: 'Monthly Sales (Last 7 Months)'),
        legend: const Legend(isVisible: true, position: LegendPosition.top),
        tooltipBehavior: tooltipBehavior,
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.months,
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
            width: 0.3,
            color: ColorName.blue200,
          )
        ],
      ),
    );
  }
}
