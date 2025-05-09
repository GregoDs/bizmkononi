import 'package:biz_mkononi/features/products/repo/products_repo.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';
import '../../customers/models/customers.dart';
import '../../products/cubit/products_cubit.dart';
import '../cubit/general.dart';
import '../cubit/sales_cubit.dart';
import '../models/sales_model.dart';
import '../models/single_sales_model.dart';
import '../repo/sales_repo.dart';

class AddSale extends StatefulWidget {
  const AddSale({super.key, this.data});
  final SingleSalesModel? data;

  @override
  State<AddSale> createState() => _AddSaleState();
}

class _AddSaleState extends State<AddSale> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final SalesCubit salesCubit = SalesCubit(SalesRepo());
  final SelectedSaleCubit selectedSaleCubit = SelectedSaleCubit();
  final ProductsCubit productsCubit = ProductsCubit(ProductsRepo());
  final SelectedCustomerCubit selectedCustomerCubit = SelectedCustomerCubit();
  final CustomersCubit customersCubit = CustomersCubit(CustomersRepo());

  final customerController = TextEditingController();
  final amountChargedController = TextEditingController();
  final amountPaidController = TextEditingController();
  CustomersModelRow? customersModelRow;

  final customerKey = 'saleCustomer';
  final amountChargedKey = 'saleAmountCharged';
  final amountPaidKey = 'saleAmountPaid';

  addSale(bool isEdit) async {
    double amountPaid = double.parse(amountPaidController.text);
    double amountCharged = double.parse(amountChargedController.text);
    int paid = amountPaid.toInt();
    int charged = amountCharged.toInt();
    Map<String, dynamic> data = {
      'customerId':
          isEdit ? widget.data!.customerId : selectedCustomerCubit.state!.id,
      'amountCharged': charged.toString(),
      'amountPaid': paid.toString(),
      "saleItems": selectedSaleCubit.state
    };
    isEdit
        ? salesCubit.editSale(
            widget.data!.id!,
            data,
          )
        : salesCubit.addSale(data);
  }

  setDatafields() async {
    await productsCubit.getProducts();
    await customersCubit.getCustomers();
    if (widget.data != null) {
      // customerController.text = widget.data.customer.name;
      // selectedCustomerCubit.setSelectedCategory(
      customersModelRow = CustomersModelRow(
        id: widget.data!.customer!.id,
        name: widget.data!.customer!.name,
        email: widget.data!.customer!.email,
        userId: widget.data!.customer!.userId,
        phone: widget.data!.customer!.phone,
        description: widget.data!.customer!.description,
        gender: widget.data!.customer!.gender,
        yearOfBirth: widget.data!.customer!.yearOfBirth,
        createdAt: widget.data!.customer!.createdAt,
        updatedAt: widget.data!.customer!.updatedAt,
      );
      // );
      for (var item in widget.data!.saleItems!) {
        selectedSaleCubit.addProduct(
          SaleProduct(
            productId: item.productId!,
            salePrice: item.salePrice!,
            quantity: item.quantity.toString(),
            productName: item.product!.name!,
          ),
        );
      }
      customerController.text = customersModelRow!.name!;
      amountChargedController.text = widget.data!.amountCharged!;
      amountPaidController.text = widget.data!.amountPaid!;
      setState(() {});
    }
    // formValidationCubit.validateField(customerKey, widget.data != null);
    formValidationCubit.validateField(amountChargedKey, widget.data != null);
    formValidationCubit.validateField(amountPaidKey, widget.data != null);
  }

  @override
  void initState() {
    setDatafields();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    customerController.clear();
    amountChargedController.clear();
    amountPaidController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.blue200,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: ColorName.lightGrey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: ColorName.blue200,
          centerTitle: true,
          title: AppText.medium(
            widget.data == null ? 'Add Sale' : 'Edit Sale',
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<SalesCubit, SalesState>(
            bloc: salesCubit,
            listener: (context, state) {
              if (state is SalesAdded) {
                showSuccess(context, 'Good job, changes made Successfully');
                Navigator.pop(context, true);
              } else if (state is SalesError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(
                        left: 23,
                        right: 23,
                        bottom: 23,
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              }
            },
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
              }
              return BlocBuilder<ProductsCubit, ProductsState>(
                bloc: productsCubit,
                builder: (context, productsState) {
                  if (productsState is ProductsLoading) {
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
                  } else if (productsState is ProductsLoaded) {
                    var products = productsState.data;
                    return BlocBuilder<FormValidationCubit, Map<String, bool>>(
                      bloc: formValidationCubit,
                      builder: (context, state) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 15.h,
                              left: 15.w,
                              right: 15.w,
                              bottom: 80.h,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorName.whiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.medium(
                                      'Select Customer',
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    widget.data != null
                                        ? CustomTextField(
                                            controller: customerController,
                                            formValidationCubit:
                                                formValidationCubit,
                                            readOnly: true,
                                            fieldId: amountPaidKey,
                                            fillColor: ColorName.textfieldColor,
                                            // validator: (value) {
                                            //   if (value == null ||
                                            //       value.isEmpty) {
                                            //     return 'Please enter some text';
                                            //   }

                                            //   return null;
                                            // },
                                          )
                                        : Container(
                                            width: ScreenUtil().screenWidth,
                                            height: ScreenUtil().setHeight(50),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorName.textfieldColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: ColorName.blackColor,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 8.0,
                                                      ),
                                                      child: BlocBuilder<
                                                          CustomersCubit,
                                                          CustomersState>(
                                                        bloc: customersCubit,
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                              is CustomersLoaded) {
                                                            return BlocBuilder<
                                                                SelectedCustomerCubit,
                                                                CustomersModelRow?>(
                                                              bloc:
                                                                  selectedCustomerCubit,
                                                              builder: (context,
                                                                  selectedState) {
                                                                final selectedCustomer =
                                                                    selectedCustomerCubit
                                                                        .state;
                                                                final selectedCustomerName =
                                                                    selectedCustomer
                                                                            ?.name ??
                                                                        'Select Customer';
                                                                return DropdownButtonHideUnderline(
                                                                  child: DropdownButton<
                                                                      CustomersModelRow>(
                                                                    value:
                                                                        selectedCustomer,
                                                                    items: state
                                                                        .data
                                                                        .map<
                                                                            DropdownMenuItem<CustomersModelRow>>(
                                                                      (CustomersModelRow
                                                                          category) {
                                                                        return DropdownMenuItem<
                                                                            CustomersModelRow>(
                                                                          value:
                                                                              category,
                                                                          child:
                                                                              Text(
                                                                            category.name ??
                                                                                '',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: ColorName.blackColor,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList(),
                                                                    onChanged:
                                                                        (CustomersModelRow?
                                                                            newValue) {
                                                                      selectedCustomerCubit
                                                                          .setSelectedCategory(
                                                                              newValue);
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .arrow_drop_down,
                                                                        color: ColorName
                                                                            .blackColor),
                                                                    iconSize:
                                                                        24,
                                                                    isExpanded:
                                                                        true,
                                                                    underline:
                                                                        const SizedBox(),
                                                                    hint: Text(
                                                                      selectedCustomerName,
                                                                      style:
                                                                          TextStyle(
                                                                        color: ColorName
                                                                            .mainGrey,
                                                                        fontSize:
                                                                            14.sp,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            return SpinKitWave(
                                                              size: 20,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return const DecoratedBox(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ColorName
                                                                        .primaryColor,
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    AppText.medium(
                                      'Selected Products',
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Container(
                                      height: 200,
                                      width: ScreenUtil().screenWidth,
                                      padding: EdgeInsets.all(8.h),
                                      decoration: BoxDecoration(
                                        color: ColorName.textfieldColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: BlocBuilder<SelectedSaleCubit,
                                          List<SaleProduct>>(
                                        bloc: selectedSaleCubit,
                                        builder: (context, selectedSaleState) {
                                          if (selectedSaleState.isEmpty) {
                                            return Center(
                                              child: AppText.medium(
                                                'Please add an item',
                                              ),
                                            );
                                          }
                                          return ListView.builder(
                                            itemCount: selectedSaleState.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              var item =
                                                  selectedSaleState[index];
                                              return Container(
                                                padding: EdgeInsets.all(8.h),
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 3.h,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: ColorName.whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        AppText.medium(
                                                          item.productName,
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        AppText.medium(
                                                          item.quantity,
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        AppText.medium(
                                                          'Ksh: ${item.salePrice}',
                                                        ),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                        onTap: () =>
                                                            selectedSaleCubit
                                                                .removeProduct(
                                                                    item),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ))
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 200,
                                          child: CustomButton(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CenterPopup(
                                                    data: products,
                                                    selectedSaleCubit:
                                                        selectedSaleCubit,
                                                  );
                                                },
                                              );
                                            },
                                            text: 'Add Product',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    AppText.medium(
                                      'Amount Charged',
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    BlocBuilder<SelectedSaleCubit,
                                        List<SaleProduct>>(
                                      bloc: selectedSaleCubit,
                                      builder: (context, state) {
                                        amountChargedController.text =
                                            selectedSaleCubit
                                                .getTotalPrice()
                                                .toString();
                                        amountChargedController.text != '0.0'
                                            ? formValidationCubit.validateField(
                                                amountChargedKey,
                                                true,
                                              )
                                            : null;
                                        return CustomTextField(
                                          readOnly: false,
                                          controller: amountChargedController,
                                          formValidationCubit:
                                              formValidationCubit,
                                          fieldId: amountChargedKey,
                                          fillColor: ColorName.textfieldColor,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }

                                            return null;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    AppText.medium(
                                      'Amount Paid',
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    CustomTextField(
                                      controller: amountPaidController,
                                      formValidationCubit: formValidationCubit,
                                      fieldId: amountPaidKey,
                                      fillColor: ColorName.textfieldColor,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }

                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 100.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              );
            },
          ),
        ),

        bottomNavigationBar: Container(
          color: Colors.transparent,
          height: 60.h,
          child: BlocBuilder<FormValidationCubit, Map<String, bool>>(
            bloc: formValidationCubit,
            builder: (context, state) {
              bool isFormValid = formValidationCubit.isFormValid();
              return Container(
                margin: EdgeInsets.only(bottom: 20.h, right: 20.w, left: 20.w),
                width: 300.w,
                child: CustomButton(
                  onTap: isFormValid &&
                          selectedCustomerCubit.state != null &&
                          selectedSaleCubit.state.isNotEmpty
                      ? () async {
                          await addSale(false);
                        }
                      : isFormValid && widget.data != null
                          ? () async {
                              await addSale(true);
                            }
                          : () {},
                  text: 'Submit',
                  color: isFormValid && selectedSaleCubit.state.isNotEmpty
                      ? ColorName.primaryColor
                      : ColorName.mainGrey,
                  radius: 20,
                  fontWeight: FontWeight.normal,
                  textColor: isFormValid && selectedSaleCubit.state.isNotEmpty
                      ? ColorName.whiteColor
                      : ColorName.lightGrey,
                ),
              );
            },
          ),
        ),
        // floatingActionButton:
        //     BlocBuilder<FormValidationCubit, Map<String, bool>>(
        //   bloc: formValidationCubit,
        //   builder: (context, state) {
        //     bool isFormValid = formValidationCubit.isFormValid();
        //     return Container(
        //       margin: EdgeInsets.only(bottom: 20.h),
        //       width: 300.w,
        //       child: CustomButton(
        //         onTap: isFormValid && selectedCustomerCubit.state != null
        //             ? () async {
        //                 await addSale(false);
        //               }
        //             : isFormValid && widget.data != null
        //                 ? () async {
        //                     await addSale(true);
        //                   }
        //                 : () {},
        //         text: 'Submit',
        //         color:
        //             isFormValid ? ColorName.primaryColor : ColorName.mainGrey,
        //         radius: 20,
        //         fontWeight: FontWeight.normal,
        //         textColor:
        //             isFormValid ? ColorName.whiteColor : ColorName.lightGrey,
        //       ),
        //     );
        //   },
        // ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
}

class CenterPopup extends StatefulWidget {
  const CenterPopup(
      {super.key, required this.data, required this.selectedSaleCubit});

  final List<ProductsModelRow> data;
  final SelectedSaleCubit selectedSaleCubit;

  @override
  State<CenterPopup> createState() => _CenterPopupState();
}

class _CenterPopupState extends State<CenterPopup> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final ProductsCubit productsCubit = ProductsCubit(ProductsRepo());
  final SubTotalCubit subTotalCubit = SubTotalCubit();
  // final SelectedSupplyCubit selectedSupplyCubit = SelectedSupplyCubit();

  final productQuantityController = TextEditingController();
  final productPriceController = TextEditingController();

  final prodQuantityKey = 'saleProdQuantity';
  final prodPriceKey = 'saleProdPrice';

  setFields() {
    formValidationCubit.validateField(prodQuantityKey, false);
    formValidationCubit.validateField(prodPriceKey, false);
  }

  @override
  void initState() {
    // productsCubit.getProducts();
    setFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 10),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppBar(
                  leading: const Icon(Icons.verified_user),
                  elevation: 0,
                  title: AppText.medium(
                    'Product Details',
                    fontSize: 16,
                  ),
                  centerTitle: true,
                ),
                SizedBox(height: 20.h),
                AppText.medium(
                  'Product Name',
                  color: Colors.black,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Column(
                  children: [
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil()
                          .setHeight(50), // Convert 50 to cubic value
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: ColorName.textfieldColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: ColorName.blackColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Center(
                          child: BlocBuilder<ProductsCubit, ProductsState>(
                            bloc: productsCubit,
                            builder: (context, state) =>
                                DropdownButton<ProductsModelRow>(
                              value: productsCubit.selectedProduct,
                              onChanged: (ProductsModelRow? newValue) {
                                productsCubit.setSelectedProduct(newValue!);
                              },
                              items: widget.data
                                  .map<DropdownMenuItem<ProductsModelRow>>(
                                (ProductsModelRow product) {
                                  return DropdownMenuItem<ProductsModelRow>(
                                    value: product,
                                    child: Text(
                                      product.name!,
                                      style: TextStyle(
                                        color: ColorName.blackColor,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                              ),
                              dropdownColor: Colors.white,
                              icon: const Icon(Icons.arrow_drop_down),
                              hint: Text(
                                'Select Product',
                                style: TextStyle(
                                  color: ColorName.mainGrey,
                                  fontSize: 14.sp,
                                ),
                              ),
                              isExpanded: true,
                              iconSize: 24,
                              iconEnabledColor: ColorName.mainGrey,
                              underline: const SizedBox(),
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                AppText.medium(
                  'Quantity',
                  color: Colors.black,
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextFormField(
                  maxLines: 1,
                  controller: productQuantityController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }

                    final enteredQuantity = int.tryParse(value);
                    final availableStock =
                        productsCubit.selectedProduct?.stock ?? 0;

                    if (enteredQuantity == null) {
                      return 'Please enter a valid number';
                    }

                    if (enteredQuantity > availableStock) {
                      return 'Only $availableStock items available in stock';
                    }

                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) async {
                    // Validate the field and calculate the price
                    formValidationCubit.validateField(
                      prodQuantityKey,
                      value.isNotEmpty,
                    );

                    final enteredQuantity = double.tryParse(value) ?? 0;
                    final sellingPrice = double.tryParse(
                            productsCubit.selectedProduct!.sellingPrice!) ??
                        0.0;

                    // Update the price field
                    final calculatedPrice = enteredQuantity * sellingPrice;
                    productPriceController.text =
                        calculatedPrice.toStringAsFixed(2);

                    formValidationCubit.validateField(
                      prodPriceKey,
                      value.isNotEmpty,
                    );

                    subTotalCubit.updateProduct(
                      enteredQuantity,
                      calculatedPrice,
                    );
                  },
                  decoration: InputDecoration(
                    hintText:
                        "Write a summary and any detail about your Product",
                    hintStyle: TextStyle(
                      color: ColorName.mainGrey,
                      fontSize: 14.sp,
                      fontFamily: FontFamily.lato,
                    ),
                    filled: true,
                    fillColor: ColorName.textfieldColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ColorName.lightGrey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ColorName.lightGrey),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: ColorName.blackColor,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                AppText.medium(
                  'Price',
                  color: Colors.black,
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextFormField(
                  maxLines: 1,
                  controller: productPriceController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }

                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) async {
                    formValidationCubit.validateField(
                      prodPriceKey,
                      value.isNotEmpty,
                    );
                    subTotalCubit.updateProduct(
                      double.tryParse(productQuantityController.text) ?? 0,
                      double.tryParse(value) ?? 0,
                    );
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: ColorName.mainGrey,
                      fontSize: 14.sp,
                      fontFamily: FontFamily.lato,
                    ),
                    filled: true,
                    fillColor: ColorName.textfieldColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ColorName.lightGrey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ColorName.lightGrey),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: ColorName.blackColor,
                    fontSize: 16.sp,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<SubTotalCubit, double>(
                  bloc: subTotalCubit,
                  builder: (context, state) {
                    return RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        children: [
                          AppTextSpan.medium('Sub Total Ksh: ',
                              color: ColorName.blackColor),
                          AppTextSpan.medium(
                            state.toString(),
                            color: ColorName.primaryColor,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100.w,
                      height: 30.h,
                      child: CustomButton(
                        onTap: () => Navigator.pop(context),
                        text: 'Cancel',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        radius: 20,
                        color: ColorName.mainGrey,
                        textColor: ColorName.blackColor,
                      ),
                    ),
                    BlocBuilder<FormValidationCubit, Map<String, bool>>(
                      bloc: formValidationCubit,
                      builder: (context, state) {
                        bool isFormValid = formValidationCubit.isFormValid();
                        return SizedBox(
                          width: 100.w,
                          height: 30.h,
                          child: CustomButton(
                            onTap: () async {
                              widget.selectedSaleCubit.addProduct(
                                SaleProduct(
                                  productId: productsCubit.selectedProduct!.id!,
                                  productName:
                                      productsCubit.selectedProduct!.name!,
                                  salePrice: subTotalCubit.state.toString(),
                                  quantity: productQuantityController.text,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            text: 'Save',
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            radius: 20,
                            color: isFormValid &&
                                    productsCubit.selectedProduct != null
                                ? ColorName.blue200
                                : ColorName.mainGrey,
                            textColor: isFormValid &&
                                    productsCubit.selectedProduct != null
                                ? ColorName.whiteColor
                                : ColorName.lightGrey,
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
