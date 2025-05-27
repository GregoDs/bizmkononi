import 'package:biz_mkononi/features/sales/cubit/sales_cubit.dart';
import 'package:biz_mkononi/features/sales/repo/sales_repo.dart';
import 'package:flutter/cupertino.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Set your desired height here
        child: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: ColorName.primaryColor,
          centerTitle: true,
          title: AppText.medium(
            'Sales Detail',
            color: Colors.white,
          ),
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
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    // Customer Details Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: ColorName.primaryColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.person_outline, color: ColorName.primaryColor),
                                SizedBox(width: 10.w),
                                AppText.medium(
                                  'Customer Details',
                                  color: ColorName.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Name', data.customer?.name ?? 'N/A', Icons.person_outline),
                                _buildDetailRow('Email', data.customer?.email ?? 'N/A', Icons.email_outlined),
                                _buildDetailRow('Phone', data.customer?.phone ?? 'N/A', Icons.phone_outlined),
                                _buildDetailRow('Gender', data.customer?.gender ?? 'N/A', Icons.person),
                                _buildDetailRow('Created At', convertToHumanReadableDate(data.customer?.createdAt.toString() ?? ''), Icons.date_range_outlined),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Products Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: ColorName.primaryColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.shopping_cart_outlined, color: ColorName.primaryColor),
                                SizedBox(width: 10.w),
                                AppText.medium(
                                  'Products',
                                  color: ColorName.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          if (products != null && products.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                var productItem = products[index];
                                return Container(
                                  padding: EdgeInsets.all(15.w),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow('Product', productItem.product?.name ?? 'N/A', Icons.production_quantity_limits_outlined),
                                      _buildDetailRow('Product Type', productItem.product?.productType ?? 'N/A', Icons.category_outlined),
                                      _buildDetailRow('Quantity', productItem.quantity.toString(), Icons.numbers_outlined),
                                      _buildDetailRow('Selling Price', 'Ksh ${productItem.product?.sellingPrice ?? 'N/A'}', Icons.price_change_outlined),
                                      _buildDetailRow('Total Amount', 'Ksh ${productItem.totalAmount ?? 'N/A'}', Icons.attach_money_outlined),
                                    ],
                                  ),
                                );
                              },
                            )
                          else
                            Padding(
                              padding: EdgeInsets.all(15.w),
                              child: AppText.medium('No products found for this sale.'),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Sale Summary Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: ColorName.primaryColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.receipt_long_outlined, color: ColorName.primaryColor),
                                SizedBox(width: 10.w),
                                AppText.medium(
                                  'Sale Summary',
                                  color: ColorName.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Grand Total', 'Ksh ${data.totalAmount ?? 'N/A'}', Icons.price_check_outlined),
                                _buildDetailRow('Charged Amount', 'Ksh ${data.amountCharged ?? 'N/A'}', Icons.money_outlined),
                                _buildDetailRow('Paid Amount', 'Ksh ${data.amountPaid ?? 'N/A'}', Icons.payments_outlined),
                                _buildDetailRow(
                                  'Balance',
                                  'Ksh ${((double.tryParse(data.amountCharged ?? '0') ?? 0) - (double.tryParse(data.amountPaid ?? '0') ?? 0)).toStringAsFixed(2)}',
                                  Icons.account_balance_wallet_outlined,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100.h),
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

  Widget _buildDetailRow(String label, String value, [IconData? icon]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: ColorName.mainGrey),
                SizedBox(width: 8.w),
              ],
              AppText.medium(
                label,
                color: ColorName.mainGrey,
              ),
            ],
          ),
          AppText.medium(
            value,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppText.medium(
                  'Confirm Delete',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                SizedBox(height: 20.h),
                AppText.medium(
                  'Are you sure you want to delete this sale record?',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: CustomButton(
                        onTap: () => Navigator.of(context).pop(),
                        text: 'Cancel',
                        color: ColorName.mainGrey,
                        textColor: ColorName.blackColor,
                        radius: 8,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomButton(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await salesCubit.deleteSale(id);
                        },
                        text: 'Delete',
                        color: Colors.red,
                        radius: 8,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
