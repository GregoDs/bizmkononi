import 'dart:convert';

import 'package:biz_mkononi/features/finance/profits/repo/profits_repo.dart';
import 'package:biz_mkononi/features/finance/profits/ui/graphs/monthly_insights.dart';
import 'package:biz_mkononi/features/finance/profits/ui/graphs/weekly_insights.dart';
import 'package:biz_mkononi/features/finance/profits/ui/graphs/yearly_insights.dart';
import 'package:flutter/services.dart';

import '../../../../exports.dart';
import '../cubit/profits_cubit.dart';
import '../models/profits.dart';
import '../../../../utils/globals/global.dart' as globals;
import 'graphs/daily_insights.dart';

class ProfitsInsight extends StatefulWidget {
  const ProfitsInsight({super.key});

  @override
  State<ProfitsInsight> createState() => _ProfitsInsightState();
}

class _ProfitsInsightState extends State<ProfitsInsight> {
  ProfitsCubit profitsCubit = ProfitsCubit(ProfitInsightRepo());
  final DateTime dateTimeNow = DateTime.now();
  List<String> frequency = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  int selectedIndex = 0;
  TooltipBehavior? _dailytooltipBehavior;
  TooltipBehavior? _weeklytooltipBehavior;
  TooltipBehavior? _monthlytooltipBehavior;
  TooltipBehavior? _yearlytooltipBehavior;
  // ZoomPanBehavior? _zoomPanBehavior;
  List<ProfitsInsights> _dailyChartData = [];
  List<ProfitsInsights> _weeklyChartData = [];
  List<ProfitsInsights> _monthlyChartData = [];
  List<ProfitsInsights> _yearlyChartData = [];

  @override
  void initState() {
    getData();
    _dailytooltipBehavior = TooltipBehavior(enable: true);
    _weeklytooltipBehavior = TooltipBehavior(enable: true);
    _monthlytooltipBehavior = TooltipBehavior(enable: true);
    _yearlytooltipBehavior = TooltipBehavior(enable: true);
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
    var newDate = DateTime(now.year - 1, now.month, now.day - 7);
    var weekDate = DateTime(now.year - 1, now.month, now.weekday - 7, now.day);
    var monthDate = DateTime(now.year - 1, now.month - 7, now.day);
    var yearDate = DateTime(now.year - 7, now.month, now.day);
    var revenueDate = DateTime(now.year - 50, now.month, now.day);
    var tz = now.timeZoneOffset;

    Map<String, dynamic> dailydata = {
      'group': 'day',
      'from': newDate,
      'to': now,
      'tz': tz
    };
    Map<String, dynamic> weekdata = {
      'group': 'week',
      'from': weekDate,
      'to': now,
      'tz': tz
    };
    Map<String, dynamic> monthdata = {
      'group': 'month',
      'from': monthDate,
      'to': now,
      'tz': tz
    };
    Map<String, dynamic> yeardata = {
      'group': 'year',
      'from': yearDate,
      'to': now,
      'tz': tz
    };

    Map<String, dynamic> revenueData = {
      'from': revenueDate,
      'to': now,
    };

    Map<String, dynamic> customerChurnData = {
      'from': revenueDate,
      'to': now,
    };

    // Daily Profit
    await profitsCubit.getProfitInsights(
      '/businesses/${globals.selectedBusiness}/profits-analytics/grouped-profits',
      dailydata,
    );

    // Week Profit
    await profitsCubit.getProfitInsights(
      '/businesses/${globals.selectedBusiness}/profits-analytics/grouped-profits',
      weekdata,
    );

    // Month Profit
    await profitsCubit.getProfitInsights(
      '/businesses/${globals.selectedBusiness}/profits-analytics/grouped-profits',
      monthdata,
    );

    // Year Profit
    await profitsCubit.getProfitInsights(
      '/businesses/${globals.selectedBusiness}/profits-analytics/grouped-profits',
      yeardata,
    );
    // Total Sales
    await profitsCubit.getProfitInsights(
      '/businesses/${globals.selectedBusiness}/sales-analytics/total-sales',
      revenueData,
    );

    // Total Sales
    await profitsCubit.getProfitInsights(
      '/businesses/${globals.selectedBusiness}/customer-analytics/churn-customer-rate',
      customerChurnData,
    );

    // Total Profits
    await profitsCubit.getProfitInsights(
      '/businesses/${globals.selectedBusiness}/profits-analytics/total-profits',
      customerChurnData,
    );

    // // Churn Rate
    // await insightsCubit.getInsights(
    //   '/businesses/${globals.selectedBusiness}/customer-analytics/churn-customer-rate',
    //   revenueData,
    // );
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
            'Profit Insights',
          ),
          leading: const SizedBox(),
        ),
        body: SafeArea(
          child: BlocBuilder<ProfitsCubit, ProfitsInsightState>(
            bloc: profitsCubit,
            builder: (context, state) {
              if (state is ProfitsInsightLoading) {
                return Center(
                  child: SpinKitWave(
                    itemBuilder: (BuildContext context, int index) {
                      return const DecoratedBox(
                        decoration: BoxDecoration(
                          color: ColorName.primaryColor,
                        ),
                      );
                    },
                  ),
                );
              } else if (state is ProfitsInsightError) {
                return Center(
                  child: AppText.medium(state.message),
                );
              } else if (state is ProfitsInsightLoaded) {
                _dailyChartData = profitsInsightsFromJson(state.data[0]);
                _weeklyChartData = profitsInsightsFromJson(state.data[1]);
                _monthlyChartData = profitsInsightsFromJson(state.data[2]);
                _yearlyChartData = profitsInsightsFromJson(state.data[3]);
                var totalSale = jsonDecode(state.data[4]);
                var customerChurn = jsonDecode(state.data[5]);
                var totalProfit = jsonDecode(state.data[6]);

                List<OverallInsightsCategory> categories = [
                  OverallInsightsCategory(
                    'Total Revenue',
                    Icons.store,
                    'Ksh: ${totalProfit['total']}',
                  ),
                  OverallInsightsCategory(
                    'Total Orders',
                    Icons.scale,
                    totalSale['total'],
                  ),
                  OverallInsightsCategory(
                    'Customer Churn Rate',
                    Icons.store,
                    customerChurn['rate'].toString(),
                  ),
                ];

                return Container(
                  padding: const EdgeInsets.only(bottom: 15, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // AppText.medium(globals.selectedBusinessName!),
                      SizedBox(
                        height: ScreenUtil().screenHeight * 0.15,
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
                                    )),
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
                                ? DailyProfitsInsightsGraph(
                                    chartData: _dailyChartData,
                                    tooltipBehavior: _dailytooltipBehavior,
                                    tileText: "Sales",
                                  )
                                : selectedIndex == 1
                                    ? WeeklyProfitsInsightsGraph(
                                        chartData: _weeklyChartData,
                                        tooltipBehavior: _weeklytooltipBehavior,
                                        tileText: "Sales",
                                      )
                                    : selectedIndex == 2
                                        ? MonthlyProfitsInsightsGraph(
                                            chartData: _monthlyChartData,
                                            tooltipBehavior:
                                                _monthlytooltipBehavior,
                                            tileText: "Sales",
                                          )
                                        : YearlyProfitsInsightsGraph(
                                            chartData: _yearlyChartData,
                                            tooltipBehavior:
                                                _yearlytooltipBehavior,
                                            tileText: "Sales",
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
