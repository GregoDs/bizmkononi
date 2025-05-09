import 'package:biz_mkononi/exports.dart';

import '../../../../utils/globals/global.dart' as globals;
import '../cubit/expenses_cubit.dart';
import '../repo/expenses_repo.dart';
import 'expense_details.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final ExpensesCubit expensesCubit = ExpensesCubit(ExpensesRepo());
  // final searchController = TextEditingController();
  String searchText = '';
  final _focus = FocusNode();

  @override
  void initState() {
    expensesCubit.getExpenses();
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
          'Expenses',
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
                      BlocBuilder<ExpensesCubit, ExpensesState>(
                        bloc: expensesCubit,
                        builder: (context, state) {
                          if (state is ExpensesLoaded) {
                            return AppText.medium('Found (${state.data.length}) Expenses',
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
                          expensesCubit.getExpenses(search: value),
                      onTapOutside: (event) => _focus.unfocus(),
                      decoration: InputDecoration(
                        hintText: 'Search By Expense Title',
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
              child: BlocBuilder<ExpensesCubit, ExpensesState>(
            bloc: expensesCubit,
            builder: (context, state) {
              if (state is ExpensesLoading) {
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
              } else if (state is ExpensesLoaded) {
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
                                'You do not have any Expenses yet\nClick the button below to add them.')
                          ],
                        ),
                      )
                    :
                SingleChildScrollView(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.data.length,
                        itemBuilder: (context, index) {
                          var item = state.data[index];
                          var length = state.data.length;
                          String holder =
                              item.title.toString().toUpperCase()[0];
                          String name = item.title!;
                          String subtitle = convertToHumanReadableDate(item.createdAt.toString());
                          return ItemCardWidget(
                            index: index,
                            length: length,
                            holder: holder,
                            title: name,
                            subtitle: 'Amount: ${item.amount.toString()}',
                            subtitle1: subtitle,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExpenseDetails(
                                    expenseId: item.id!,
                                  ),
                                ),
                              );

                              // Check if result is true, then reload data
                              if (result != null && result == true) {
                                expensesCubit.getExpenses();
                              }
                            },
                          );
                        }),
                  ),
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
                      await Navigator.pushNamed(context, Routes.addExpense);
                  if (result != null && result == true) {
                    expensesCubit.getExpenses();
                  }
                },
                text: 'Add Expense',
                color: ColorName.primaryColor,
                radius: 20,
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
