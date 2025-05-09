
import 'package:biz_mkononi/features/insights/ui/overall_insight.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../exports.dart';
import '../../../utils/globals/global.dart' as globals;

class Businesses extends StatefulWidget {
  const Businesses({super.key});

  @override
  State<Businesses> createState() => _BusinessesState();
}

class _BusinessesState extends State<Businesses> {
  BusinessesCubit businessesCubit = BusinessesCubit(BusinessesRepo());
  // final Random random = Random();

  // Color _randomColor() {
  //   return Color.fromRGBO(
  //     random.nextInt(256),
  //     random.nextInt(256),
  //     random.nextInt(256),
  //     1.0,
  //   );
  // }

  @override
  void initState() {
    businessesCubit.getBusinesses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.blue200,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: ColorName.lightGrey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorName.blue200,
          centerTitle: true,
          title: AppText.medium(
            'My Businesses',
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<BusinessesCubit, BusinessesState>(
            bloc: businessesCubit,
            builder: (context, state) {
              if (state is BusinessesLoading) {
                return SpinKitWave(
                  itemBuilder: (BuildContext context, int index) {
                    return const DecoratedBox(
                      decoration: BoxDecoration(
                        color: ColorName.primaryColor,
                      ),
                    );
                  },
                );
              } else if (state is BusinessesError) {
                return Center(
                  child: AppText.medium(state.message),
                );
              } else if (state is BusinessesLoaded) {
                return state.data.isEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                                image:
                                    AssetImage(Assets.images.emptyData.path)),
                            SizedBox(
                              height: 100.h,
                            ),
                            AppText.medium(
                                'You do not have any Business yet\nClick the button below to add them.')
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.data.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var item = state.data[index];
                                  return Container(
                                    margin: index == state.data.length - 1
                                        ? const EdgeInsets.only(bottom: 100)
                                        : const EdgeInsets.only(bottom: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              leading: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: const BoxDecoration(
                                                  color: ColorName.blue200,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: AppText.large(
                                                    item.name
                                                        .toString()
                                                        .toUpperCase()[0],
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: ColorName.whiteColor,
                                                  ),
                                                ),
                                              ),
                                              title: AppText.medium(
                                                  capitalizeWord(item.name!)),
                                              subtitle: AppText.small(
                                                  convertToHumanReadableDate(
                                                      item.createdAt
                                                          .toString())),
                                              onTap: () {
                                                // Add your onTap functionality here
                                              },
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 150,
                                                  height: 30,
                                                  child: CustomButton(
                                                    onTap: () async {
                                                          Navigator.of(context)
                                                              .push(
                                                        MaterialPageRoute(
                                                          builder: ((context) =>
                                                              BusinessDetail(
                                                                  bizId: item
                                                                      .id!)),
                                                        ),
                                                      );
                                                      await businessesCubit
                                                            .getBusinesses();
                                                    },
                                                    text: 'Read More',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  height: 30,
                                                  child: CustomButton(
                                                    onTap: () async {
                                                      globals.selectedBusiness =
                                                          item.id!;
                                                      globals.selectedBusinessName =
                                                          item.name!;
                                                      globals.selectedBusinessWidget =
                                                          const OverallInsight();
                                                      Navigator.pushNamed(
                                                        context,
                                                        Routes
                                                            .businessLandingPage,
                                                      );
                                                    },
                                                    text: 'Manage',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12,
                                                    color:
                                                        ColorName.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
        floatingActionButton: SizedBox(
          width: 200.w,
          child: CustomButton(
            onTap: () async {
              final result =
                  await Navigator.pushNamed(context, Routes.addBusiness);
              if (result != null && result == true) {
                await businessesCubit.getBusinesses();
              }
            },
            text: 'Add Business',
            color: ColorName.primaryColor,
            radius: 20,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            isIconButton: true,
            widget: const Icon(
              Icons.add,
              color: ColorName.whiteColor,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }

  String getDate(String date) {
    DateTime parseDate = DateTime.parse(date);
    var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    var outputDate = outputFormat.format(parseDate);
    return outputDate.toString();
  }
}
