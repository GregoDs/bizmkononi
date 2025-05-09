import 'dart:convert';

import 'package:biz_mkononi/features/insights/cubit/insights_cubit.dart';
import 'package:biz_mkononi/features/insights/repo/insights_repo.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../utils/globals/global.dart' as globals;
import '../../../exports.dart';
import '../models/insights.dart';
import 'graphs/daily_insight.dart';
import 'graphs/month_insights.dart';

class OverallInsight extends StatefulWidget {
  const OverallInsight({super.key});

  @override
  State<OverallInsight> createState() => _OverallInsightState();
}

class _OverallInsightState extends State<OverallInsight> {
  InsightsCubit insightsCubit = InsightsCubit(InsightsRepo());
  final DateTime dateTimeNow = DateTime.now();
  List<String> frequency = ['Daily', 'Weekly'];
  int selectedIndex = 0;
  TooltipBehavior? _dailytooltipBehavior;
  TooltipBehavior? _monthlytooltipBehavior;
  // ZoomPanBehavior? _zoomPanBehavior;
  List<Insights> _daychartData = [];
  List<Insights> _monthchartData = [];

  @override
  void initState() {
    getData();
    _dailytooltipBehavior = TooltipBehavior(enable: true);
    _monthlytooltipBehavior = TooltipBehavior(enable: true);
    // _zoomPanBehavior = ZoomPanBehavior(
    //     enablePinching: true,
    //     enableDoubleTapZooming: true,
    //     enableSelectionZooming: true,
    //     selectionRectBorderColor: Colors.red,
    //     selectionRectBorderWidth: 1,
    //     selectionRectColor: Colors.grey,);
    super.initState();
  }

  getData() async {
    final now = DateTime.now();
    var dayDate = DateTime(now.year, now.month, now.day - 7);
    var monthDate = DateTime(now.year, now.month - 7, now.day);
    var revenueDate = DateTime(now.year, now.month - 1, now.day);
    var todaySaleDate = DateTime(now.year, now.month, now.day - 1);
    var tz = now.timeZoneOffset;

    Map<String, dynamic> dailyData = {
      'group': 'day',
      'from': dayDate,
      'to': now,
      'tz': tz
    };

    Map<String, dynamic> monthlyData = {
      'group': 'month',
      'from': monthDate,
      'to': now,
      'tz': tz
    };

    Map<String, dynamic> revenueData = {
      'from': revenueDate,
      'to': now,
    };

    Map<String, dynamic> totalSaleData = {
      'from': todaySaleDate,
      'to': now,
    };

    // Daily Info
    await insightsCubit.getInsights(
      '/businesses/${globals.selectedBusiness}/sales-analytics/sales-trend',
      dailyData,
    );

    // Month Info
    await insightsCubit.getInsights(
      '/businesses/${globals.selectedBusiness}/sales-analytics/sales-trend',
      monthlyData,
    );

    // Daily Info
    await insightsCubit.getInsights(
      '/businesses/${globals.selectedBusiness}/sales-analytics/total-sales',
      totalSaleData,
    );

    // Sales Today
    await insightsCubit.getInsights(
      '/businesses/${globals.selectedBusiness}/sales-analytics/total-sales',
      revenueData,
    );
    // Revenue
    await insightsCubit.getInsights(
      '/businesses/${globals.selectedBusiness}/profits-analytics/total-profits',
      revenueData,
    );

    // Churn Rate
    await insightsCubit.getInsights(
      '/businesses/${globals.selectedBusiness}/customer-analytics/churn-customer-rate',
      revenueData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.blue200,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: ColorName.lightGrey,
        appBar: AppBar(
          backgroundColor: ColorName.blue200,
          centerTitle: true,
          title: AppText.medium(
            'Overview Insights',
          ),
          leading: const SizedBox(),
        ),
        body: SafeArea(
          child: BlocBuilder<InsightsCubit, InsightsState>(
            bloc: insightsCubit,
            builder: (context, state) {
              if (state is InsightsLoading) {
                return SpinKitWave(
                  itemBuilder: (BuildContext context, int index) {
                    return const DecoratedBox(
                      decoration: BoxDecoration(
                        color: ColorName.primaryColor,
                      ),
                    );
                  },
                );
              } else if (state is InsightsError) {
                return Center(
                  child: AppText.medium(state.message),
                );
              } else if (state is InsightsLoaded) {
                String abbreviatedMonth = DateFormat('MMM').format(dateTimeNow);

                _daychartData = insightsFromJson(state.data[0]);
                _monthchartData = insightsFromJson(state.data[1]);

                var todaySale = jsonDecode(state.data[2]);
                var monthSale = jsonDecode(state.data[3]);

                var avgRevenue = jsonDecode(state.data[4]);
                var churnRate = jsonDecode(state.data[5]);

                List<OverallInsightsCategory> categories = [
                  OverallInsightsCategory(
                    'Average Revenue',
                    Icons.store,
                    'Ksh: ${avgRevenue['total']}',
                  ),
                  OverallInsightsCategory(
                    'Sales Today',
                    Icons.scale,
                    'Ksh: ${todaySale['total']}',
                  ),
                  OverallInsightsCategory(
                    '$abbreviatedMonth Sales',
                    Icons.scale,
                    'Ksh: ${monthSale['total']}',
                  ),
                  OverallInsightsCategory(
                    '$abbreviatedMonth Churn Rate',
                    Icons.store,
                    'Ksh: ${churnRate['rate']}',
                  ),
                ];

                return Container(
                  padding: const EdgeInsets.only(bottom: 15, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // AppText.medium(globals.selectedBusinessName!),
                      SizedBox(
                        height: ScreenUtil().screenHeight * 0.2,
                        child: ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var item = categories[index];
                            return Container(
                              margin: index == 0
                                  ? const EdgeInsets.only(
                                      left: 15,
                                      right: 20,
                                    )
                                  : const EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(15.h),
                              decoration: BoxDecoration(
                                color: ColorName.whiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: ColorName.lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        item.iconData,
                                        color: ColorName.mainGrey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  AppText.medium(
                                    item.title,
                                    color: ColorName.mainGrey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  AppText.medium(item.data),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                      // CustomButton(
                      //   onTap: () => Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => BarChartSample3()),
                      //       ),
                      //   text: 'Button'),

                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: frequency.length,
                          itemBuilder: (context, index) {
                            var item = frequency[index];
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedIndex = index),
                              child: Card(
                                color: selectedIndex == index
                                    ? ColorName.primaryColor
                                    : ColorName.whiteColor,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    child: AppText.medium(
                                      item,
                                      color: selectedIndex == index
                                          ? ColorName.whiteColor
                                          : ColorName.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: ColorName.whiteColor,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: ColorName.mainGrey,
                            ),
                          ),
                          child: SizedBox(
                            child: selectedIndex == 0
                                ? DayInsightsGraph(
                                    chartData: _daychartData,
                                    tooltipBehavior: _dailytooltipBehavior,
                                    tileText: "Ksh:",
                                  )
                                : MonthInsightsGraph(
                                    chartData: _monthchartData,
                                    tooltipBehavior: _monthlytooltipBehavior,
                                    tileText: "Ksh:",
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class OverallInsightsCategory {
  final String title;
  final IconData iconData;
  final String data;

  OverallInsightsCategory(this.title, this.iconData, this.data);
}
