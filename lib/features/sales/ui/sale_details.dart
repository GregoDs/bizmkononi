import 'package:biz_mkononi/features/sales/cubit/sales_cubit.dart';
import 'package:biz_mkononi/features/sales/repo/sales_repo.dart';

import '../../../exports.dart';
import 'add_sale.dart';

class SaleDetails extends StatefulWidget {
  const SaleDetails({
    super.key,
    required this.saleId,
  });

  final String saleId;

  @override
  State<SaleDetails> createState() => _SaleDetailsState();
}

class _SaleDetailsState extends State<SaleDetails> {
  final SalesCubit salesCubit = SalesCubit(SalesRepo());

  @override
  void initState() {
    salesCubit.getSingleSale(widget.saleId);
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
          'Sales Detail',
        ),
      ),
      body: BlocConsumer<SalesCubit, SalesState>(
        bloc: salesCubit,
        listener: (context, state) {
          if (state is SalesDeleted) {
            showSuccess(context, 'Good job, item deleted Successfully');
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is SalesLoading) {
            return SpinKitWave(
              itemBuilder: (BuildContext context, int index) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    color: ColorName.primaryColor,
                  ),
                );
              },
            );
          } else if (state is SalesError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is SalesSingleLoaded) {
            var data = state.data;
            var products = data.saleItems;
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText.medium(
                                      'Name: ${data.customer!.name!}'),
                                  AppText.medium(data.customer!.phone!),
                                  AppText.medium(data.customer!.email!),
                                  AppText.medium(convertToHumanReadableDate(
                                      data.createdAt.toString()))
                                ],
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
                          const SizedBox(
                            height: 15,
                          ),
                          for (int i = 0; i < products!.length; i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText.medium(
                                  'Name: ${products[i].product!.name!}',
                                ),
                                AppText.medium(
                                  'Selling Price: ${products[i].product!.sellingPrice!}',
                                ),
                                AppText.medium(
                                  'Quatity: ${products[i].quantity.toString()}',
                                ),
                                AppText.medium(
                                  'Sub-Total: ${calculateSubTotal(products[i].quantity.toString(), products[i].product!.sellingPrice.toString())}',
                                )
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
                                'Total Amount: ${data.totalAmount}',
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              AppText.medium(
                                'Charged Amount: ${data.amountCharged}',
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              AppText.medium(
                                'Paid Amount: ${data.amountPaid}',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // AppText.medium(state.data.customer!.name!),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<SalesCubit, SalesState>(
        bloc: salesCubit,
        builder: (context, state) {
          if (state is SalesSingleLoaded) {
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
                            builder: (context) => AddSale(
                              data: state.data,
                            ),
                          ),
                        );
                        if (result != null && result == true) {
                          salesCubit.getSingleSale(widget.saleId);
                        }
                      },
                      text: "Edit",
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: CustomButton(
                      onTap: () => _showMyDialog(context, widget.saleId),
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
                Text('Would you like to remove the Record ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
                overlayColor: WidgetStateProperty.all<Color>(Colors.redAccent),
              ),
              child: const Text('Remove'),
              onPressed: () async {
                Navigator.of(context).pop();
                await salesCubit.deleteSale(id);
              },
            ),
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
