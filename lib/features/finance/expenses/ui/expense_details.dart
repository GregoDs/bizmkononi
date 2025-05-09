import '../../../../exports.dart';
import '../cubit/expenses_cubit.dart';
import '../repo/expenses_repo.dart';
import 'add_expense.dart';

class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({
    super.key,
    required this.expenseId,
  });

  final String expenseId;

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  final ExpensesCubit expensesCubit = ExpensesCubit(ExpensesRepo());

  @override
  void initState() {
    expensesCubit.getSingleExpense(widget.expenseId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.lightGrey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: ColorName.blue200,
        centerTitle: true,
        title: AppText.medium(
          'Expense Details',
        ),
      ),
      body: BlocConsumer<ExpensesCubit, ExpensesState>(
        bloc: expensesCubit,
        listener: (context, state) {
          if (state is ExpensesDeleted) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is ExpensesLoading) {
            return SpinKitWave(
              itemBuilder: (BuildContext context, int index) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    color: ColorName.primaryColor,
                  ),
                );
              },
            );
          } else if (state is ExpensesError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is ExpensesSingleLoaded) {
            var data = state.data;
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    DetailsSection(
                      isWithoutImage: true,
                      tiles: [
                        DetailTile(
                          title: 'Title',
                          trailing: data.title!,
                        ),
                        DetailTile(
                          title: 'Amount',
                          trailing: 'Ksh ${data.amount}',
                        ),
                        DetailTile(
                          title: 'Transaction Date',
                          trailing: convertToHumanReadableDate(
                            data.createdAt.toString(),
                          ),
                        ),
                        DetailTile(
                          title: 'Description',
                          trailing: data.description!,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            );
          }
    
          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<ExpensesCubit, ExpensesState>(
        bloc: expensesCubit,
        builder: (context, state) {
          if (state is ExpensesSingleLoaded) {
            return Container(
              margin: EdgeInsets.only(left: 30.w, right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: CustomButton(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddExpense(
                              data: state.data,
                            ),
                          ),
                        );
                        if (result != null && result == true) {
                          expensesCubit.getSingleExpense(widget.expenseId);
                        }
                      },
                      text: "Edit",
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: CustomButton(
                      onTap: () => _showMyDialog(context, widget.expenseId),
                      text: "Delete",
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }
    
          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Future<void> _showMyDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to remove the Item ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
                  overlayColor:
                      WidgetStateProperty.all<Color>(Colors.redAccent),
                ),
                child: const Text('Remove'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await expensesCubit.deleteExpense(id);
                }),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
