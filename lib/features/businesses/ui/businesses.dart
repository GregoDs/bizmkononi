import 'package:biz_mkononi/features/insights/ui/overall_insight.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../exports.dart';
import '../../../utils/globals/global.dart' as globals;
import 'package:biz_mkononi/gen/fonts.gen.dart';

class Businesses extends StatefulWidget {
  const Businesses({super.key});

  @override
  State<Businesses> createState() => _BusinessesState();
}

class _BusinessesState extends State<Businesses> {
  BusinessesCubit businessesCubit = BusinessesCubit(BusinessesRepo());

  @override
  void initState() {
    businessesCubit.getBusinesses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.primaryColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: ColorName.lightGrey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorName.primaryColor,
          centerTitle: true,
          title: AppText.medium(
            'My Businesses',
            color: ColorName.whiteColor,
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<BusinessesCubit, BusinessesState>(
            bloc: businessesCubit,
            builder: (context, state) {
              if (state is BusinessesLoading) {
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
              } else if (state is BusinessesError) {
                return Center(
                  child: AppText.medium(state.message),
                );
              } else if (state is BusinessesLoaded) {
                if (state.data.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.images.emptyData.path),
                        SizedBox(height: 20.h),
                        AppText.medium(
                          'You do not have any Business yet\nClick the button below to add them.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            itemCount: state.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = state.data[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.business,
                                                size: 40),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText.medium(
                                                  capitalizeWord(item.name!),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText.small(
                                                  convertToHumanReadableDate(
                                                      item.createdAt
                                                          .toString()),
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Divider(color: Colors.grey.shade300),
                                        SizedBox(height: 12.h),
                                        AppText.small('Service'),
                                        AppText.medium(
                                          item.productType ?? 'N/A',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(height: 8.h),
                                        AppText.small('Business Name'),
                                        AppText.medium(
                                          capitalizeWord(item.name!),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(height: 8.h),
                                        // AppText.small('Ratings'),
                                        // SizedBox(height: 16.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: CustomButton(
                                                onTap: () async {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          BusinessDetail(
                                                              bizId: item.id!),
                                                    ),
                                                  );
                                                  await businessesCubit
                                                      .getBusinesses();
                                                },
                                                text: 'Read More',
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
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
                                                          .businessLandingPage);
                                                },
                                                text: 'Manage',
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                                color: ColorName.primaryColor,
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
              }
              return Container();
            },
          ),
        ),
        // const SizedBox(height: 20),
        floatingActionButton: BlocBuilder<BusinessesCubit, BusinessesState>(
          bloc: businessesCubit,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                            context, Routes.addBusiness);
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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      onTap: () async {
                        if (state is BusinessesLoaded &&
                            state.data.isNotEmpty) {
                          final selectedBusiness =
                              await showDialog<BusinessModelRows>(
                            context: context,
                            builder: (BuildContext context) {
                              return BusinessSelectionDialog(
                                  businesses: state.data);
                            },
                          );
                          if (selectedBusiness != null) {
                            globals.selectedBusiness = selectedBusiness.id!;
                            globals.selectedBusinessName =
                                selectedBusiness.name!;
                            // Navigate to the Add Sale page for the selected business
                            Navigator.pushNamed(context, Routes.addSale);
                          }
                        } else if (state is BusinessesLoaded &&
                            state.data.isEmpty) {
                          // Optionally show a message if there are no businesses to select from
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'No businesses available to make a sale.'),
                            ),
                          );
                        }
                      },
                      text: 'Make Sale',
                      color: Colors.green, // Match Add Business button color
                      radius: 20, // Match Add Business button radius
                      fontSize: 14, // Match Add Business button font size
                      fontWeight: FontWeight
                          .normal, // Match Add Business button font weight
                      isIconButton: true,
                      widget: const Icon(
                        Icons.shopping_cart, // Example icon, change if needed
                        color: ColorName.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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

class BusinessSelectionDialog extends StatefulWidget {
  const BusinessSelectionDialog({Key? key, required this.businesses})
      : super(key: key);

  final List<BusinessModelRows> businesses;

  @override
  _BusinessSelectionDialogState createState() =>
      _BusinessSelectionDialogState();
}

class _BusinessSelectionDialogState extends State<BusinessSelectionDialog> {
  BusinessModelRows? _selectedBusiness;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AppText.medium(
                      'Select a Business',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<BusinessModelRows>(
                    decoration: InputDecoration(
                      labelText: 'Business',
                      labelStyle: const TextStyle(fontFamily: FontFamily.lato),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: _selectedBusiness,
                    items: widget.businesses.map((business) {
                      return DropdownMenuItem<BusinessModelRows>(
                        value: business,
                        child: Text(
                          business.name ?? 'Unnamed Business',
                          style: const TextStyle(fontFamily: FontFamily.lato),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedBusiness = newValue;
                      });
                    },
                    style: const TextStyle(
                      fontFamily: FontFamily.lato,
                      color: ColorName.blackColor
                      ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: 38,
                          child: CustomButton(
                            onTap: () => Navigator.of(context).pop(),
                            text: 'Cancel',
                            color: ColorName.mainGrey,
                            textColor: ColorName.blackColor,
                            radius: 8,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: SizedBox(
                          height: 38,
                          child: CustomButton(
                            onTap: _selectedBusiness != null
                                ? () {
                                    globals.selectedBusiness =
                                        _selectedBusiness!.id!;
                                    globals.selectedBusinessName =
                                        _selectedBusiness!.name!;
                                    Navigator.of(context).pop(_selectedBusiness);
                                  }
                                : null,
                            text: 'Select',
                            color: _selectedBusiness != null
                                ? ColorName.primaryColor
                                : ColorName.mainGrey,
                            textColor: ColorName.whiteColor,
                            radius: 8,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}