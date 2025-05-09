import 'package:biz_mkononi/exports.dart';

import '../../../utils/globals/global.dart' as globals;
import '../cubit/sales_cubit.dart';
import '../repo/sales_repo.dart';
import 'sale_details.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  final SalesCubit salesCubit = SalesCubit(SalesRepo());
  // final searchController = TextEditingController();
  String searchText = '';
  final _focus = FocusNode();

  @override
  void initState() {
    salesCubit.getSales();
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Rebuild UI to reflect focus change
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.lightGrey,
      appBar: AppBar(
        backgroundColor: ColorName.blue200,
        title: AppText.medium(
          'Sales',
        ),
        leading: const SizedBox(),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                Container(
                  height: 100,
                  width: ScreenUtil().screenWidth,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                  decoration: const BoxDecoration(
                    color: ColorName.blue200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.medium(
                          capitalizeWord(globals.selectedBusinessName!),
                          color: ColorName.whiteColor),
                      BlocBuilder<SalesCubit, SalesState>(
                        bloc: salesCubit,
                        builder: (context, state) {
                          if (state is SalesLoaded) {
                            return AppText.medium(
                                'Found (${state.data.length}) Sales',
                                color: ColorName.whiteColor);
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 15,
                  right: 15,
                  child: SizedBox(
                    height: 50,
                    width: ScreenUtil().screenWidth * 0.8,
                    child: TextFormField(
                      focusNode: _focus,
                      cursorWidth: 1.0,
                      cursorHeight: 20,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) => salesCubit.getSales(search: value),
                      decoration: InputDecoration(
                        hintText: 'Search By Customer name',
                        hintStyle: TextStyle(
                          color: ColorName.mainGrey,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: FontFamily.lato,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide.none,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ColorName.mainGrey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: BlocBuilder<SalesCubit, SalesState>(
            bloc: salesCubit,
            builder: (context, state) {
              if (state is SalesLoading) {
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
              } else if (state is SalesLoaded) {
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
                                'You do not have any Sales yet\nClick the button below to add them.')
                          ],
                        ),
                      )
                    :
                SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        var item = state.data[index];
                        var length = state.data.length;
                        String holder =
                            item.customer!.name.toString().toUpperCase()[0];
                        String name = item.customer!.name!;
                        return ItemCardWidget(
                          index: index,
                          length: length,
                          holder: holder,
                          title: name,
                          subtitle: 'Amount Paid: ${item.amountPaid!}',
                          subtitle1: convertToHumanReadableDate(item.createdAt.toString()),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SaleDetails(
                                  saleId: item.id!,
                                ),
                              ),
                            );

                            // Check if result is true, then reload data
                            if (result != null && result == true) {
                              salesCubit.getSales();
                            }
                          },
                        );
                      }),
                );
              }
              return Container();
            },
          ))
        ],
      ),
      floatingActionButton: _focus.hasFocus
          ? null
          : SizedBox(
              width: 200.w,
              child: CustomButton(
                onTap: () async {
                  final result =
                      await Navigator.pushNamed(context, Routes.addSale);
                  if (result != null && result == true) {
                    salesCubit.getSales();
                  }
                },
                text: 'Add Sale',
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
    );
  }
}
