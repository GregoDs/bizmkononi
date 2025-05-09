import 'package:biz_mkononi/features/supplies/cubit/supplies_cubit.dart';

import '../../../exports.dart';
import '../repo/supplies_repo.dart';
import 'add_supply.dart';

class SupplyDetails extends StatefulWidget {
  const SupplyDetails({
    super.key,
    required this.supplyId,
  });

  final String supplyId;

  @override
  State<SupplyDetails> createState() => _SupplyDetailsState();
}

class _SupplyDetailsState extends State<SupplyDetails> {
  final SuppliesCubit suppliesCubit = SuppliesCubit(SuppliesRepo());

  @override
  void initState() {
    suppliesCubit.getSingleSupply(widget.supplyId);
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
          'Supply Detail',
        ),
      ),
      body: BlocConsumer<SuppliesCubit, SuppliesState>(
        bloc: suppliesCubit,
        listener: (context, state) {
          if (state is SuppliesDeleted) {
            showSuccess(context, 'Good job, item deleted Successfully');
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is SuppliesLoading) {
            return SpinKitWave(
              itemBuilder: (BuildContext context, int index) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    color: ColorName.primaryColor,
                  ),
                );
              },
            );
          } else if (state is SuppliesError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is SuppliesSingleLoaded) {
            var data = state.data;
            var supplier = data.supplier;
            var products = data.supplyItems;
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText.medium('Customer'),
                          SizedBox(
                            height: 10.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText.medium('Name: ${supplier!.name!}'),
                              AppText.medium(data.supplier!.phone!),
                              AppText.medium(data.supplier!.email!),
                              AppText.medium(
                                convertToHumanReadableDate(
                                  data.createdAt.toString(),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.medium('Products'),
                          SizedBox(height: 10.h,),
                          for (int i = 0; i < products!.length; i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText.medium(
                                    'Name: ${products[i].product!.name!}'),
                                AppText.medium(
                                    'Selling Price: ${products[i].product!.sellingPrice!}'),
                                AppText.medium(
                                    'Quatity: ${products[i].quantity.toString()}'),
                                AppText.medium(
                                    'Sub-Total: ${calculateSubTotal(products[i].quantity.toString(), products[i].product!.sellingPrice.toString())}')
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.medium('Totals'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.medium(
                                  'Total Amount: ${data.totalAmount}'),
                              SizedBox(
                                height: 10.h,
                              ),
                              AppText.medium(
                                  'Charged Amount: ${data.amountCharged}'),
                              SizedBox(
                                height: 10.h,
                              ),
                              AppText.medium('Paid Amount: ${data.amountPaid}'),
                            ],
                          )
                        ],
                      ),
                    ),
                    // AppText.medium(state.data.supplier!.name!),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<SuppliesCubit, SuppliesState>(
        bloc: suppliesCubit,
        builder: (context, state) {
          if (state is SuppliesSingleLoaded) {
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
                                builder: (context) => AddSupply(
                                  data: state.data,
                                ),
                              ),
                            );
                            if (result != null && result == true) {
                              suppliesCubit.getSingleSupply(widget.supplyId);
                            }
                          },
                          text: "Edit"),
                    ),
                    SizedBox(
                      width: 150,
                      child: CustomButton(
                        onTap: () => _showMyDialog(context, widget.supplyId),
                        text: "Delete",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ));
          }

          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  double calculateSubTotal(String quantityString, String priceString) {
    double quantity = double.parse(quantityString);
    double price = double.parse(priceString);

    return quantity * price;
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
                  await suppliesCubit.deleteSupply(id);
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
