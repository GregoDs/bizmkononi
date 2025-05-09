import 'package:biz_mkononi/exports.dart';
import 'package:biz_mkononi/features/customers/ui/customer_details.dart';
import '../../../utils/globals/global.dart' as globals;

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final CustomersCubit customersCubit = CustomersCubit(CustomersRepo());
  // final searchController = TextEditingController();
  String searchText = '';
  final _focus = FocusNode();

  @override
  void initState() {
    customersCubit.getCustomers();
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
          'Customers',
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
                      BlocBuilder<CustomersCubit, CustomersState>(
                        bloc: customersCubit,
                        builder: (context, state) {
                          if (state is CustomersLoaded) {
                            return AppText.medium(
                                'Found (${state.data.length}) Customers',
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
                      onChanged: (value) =>
                          customersCubit.getCustomers(search: value),
                      decoration: InputDecoration(
                        hintText: 'Search',
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
              child: BlocBuilder<CustomersCubit, CustomersState>(
            bloc: customersCubit,
            builder: (context, state) {
              if (state is CustomersLoading) {
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
              } else if (state is CustomersLoaded) {
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
                                'You do not have any Customers yet\nClick the button below to add them.')
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
                        String holder = item.name.toString().toUpperCase()[0];
                        String name = item.name!;
                        String phone = item.phone!;
                        
                        return ItemCardWidget(
                          index: index,
                          length: length,
                          holder: holder,
                          title: name,
                          subtitle: 'Phone: $phone',
                          subtitle1: 'Email: ${item.email}',
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerDetails(
                                  customerId: item.id!,
                                ),
                              ),
                            );

                            // Check if result is true, then reload data
                            if (result != null && result == true) {
                              await customersCubit.getCustomers();
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
                      await Navigator.pushNamed(context, Routes.addCustomer);
                  if (result != null && result == true) {
                    await customersCubit.getCustomers();
                  }
                },
                text: 'Add Customer',
                color: ColorName.primaryColor,
                radius: 20,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                isIconButton: true,
                widget: Icon(
                  Icons.add,
                  color: ColorName.whiteColor,
                  size: 18.sp,
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}

// class ItemCardWidget extends StatelessWidget {
//   const ItemCardWidget({
//     super.key,
//     required this.length,
//     required this.holder,
//     required this.name,
//     required this.phone,
//     required this.index,
//     this.onTap,
//   });

//   final int index;
//   final int length;
//   final String holder;
//   final String name;
//   final String phone;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: index == length - 1
//           ? EdgeInsets.only(left: 15.w, right: 15.w, top: 5.h, bottom: 80.h)
//           : EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               ListTile(
//                 splashColor: Colors.transparent,
//                 tileColor: Colors.transparent,
//                 leading: Container(
//                   width: 50,
//                   height: 50,
//                   decoration: const BoxDecoration(
//                     color: ColorName.blue200,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: AppText.large(
//                       holder,
//                       fontWeight: FontWeight.normal,
//                       color: ColorName.whiteColor,
//                     ),
//                   ),
//                 ),
//                 title: AppText.medium(name),
//                 subtitle: AppText.small(phone),
//                 onTap: onTap,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   GestureDetector(
//                     onTap: onTap,
//                     child: AppText.medium(
//                       'View',
//                       color: ColorName.blue200,
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
