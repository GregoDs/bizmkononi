import 'package:biz_mkononi/features/employees/salaries/cubit/salaries_cubit.dart';
import 'package:biz_mkononi/features/employees/salaries/repo/salaries_repo.dart';

import '../../../../exports.dart';
import 'add_salary.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({
    super.key,
    required this.paymentId,
  });

  final String paymentId;

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final SalariesCubit salariesCubit = SalariesCubit(SalariesRepo());

  @override
  void initState() {
    salariesCubit.getSingleSalary(widget.paymentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.lightGrey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context, true),
          child: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: ColorName.blue200,
        centerTitle: true,
        title: AppText.medium(
          'Payment Detail',
        ),
      ),
      body: BlocConsumer<SalariesCubit, SalariesState>(
        bloc: salariesCubit,
        listener: (context, state) {
          if (state is SalariesDeleted) {
            showSuccess(context, 'Good job, item deleted Successfully');
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is SalariesLoading) {
            return SpinKitWave(
              itemBuilder: (BuildContext context, int index) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    color: ColorName.primaryColor,
                  ),
                );
              },
            );
          } else if (state is SalariesError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is SalariesSingleLoaded) {
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
                      isperson: true,
                      image: data.employee!.imageUrl!,
                      tiles: [
                        DetailTile(
                          title: 'Name',
                          trailing: data.employee!.name!,
                        ),
                        DetailTile(
                          title: 'Amount',
                          trailing: data.amount!,
                        ),
                        DetailTile(
                          title: 'Payment for Date',
                          trailing: convertToHumanReadableDate(
                            data.txDate.toString(),
                          ),
                        ),
                        DetailTile(
                          title: 'Description',
                          trailing: data.description!,
                        )
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
      floatingActionButton: BlocBuilder<SalariesCubit, SalariesState>(
      bloc: salariesCubit,
      builder: (context, state) {
        if (state is SalariesSingleLoaded) {
          return Container(
            height: 60.h,
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
                                  builder: (context) => AddSalary(
                                    data: state.data,
                                  ),
                                ),
                              );
                              if (result != null && result == true) {
                                salariesCubit.getSingleSalary(widget.paymentId);
                              }
                            },
                            text: "Edit",),
                      ),
                      SizedBox(
                        width: 150,
                        child: CustomButton(
                          onTap: () =>
                              _showMyDialog(context, widget.paymentId),
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
                  await salariesCubit.deleteSalaries(id);
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
