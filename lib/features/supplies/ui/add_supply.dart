import 'package:biz_mkononi/features/products/repo/products_repo.dart';
import 'package:biz_mkononi/features/suppliers/repo/suppliers_repo.dart';
import 'package:biz_mkononi/features/supplies/cubit/supplies_cubit.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';
import '../../products/cubit/products_cubit.dart';
import '../../suppliers/cubit/suppliers_cubit.dart';
import '../../suppliers/models/suppliers_model.dart';
import '../cubit/general.dart';
import '../models/single_supply_model.dart';
import '../models/supplies_model.dart';
import '../repo/supplies_repo.dart';

class AddSupply extends StatefulWidget {
  const AddSupply({super.key, this.data});
  final SingleSupplyModel? data;

  @override
  State<AddSupply> createState() => _AddSupplyState();
}

class _AddSupplyState extends State<AddSupply> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final SuppliesCubit suppliesCubit = SuppliesCubit(SuppliesRepo());
  final SelectedSupplyCubit selectedSupplyCubit = SelectedSupplyCubit();
  final ProductsCubit productsCubit = ProductsCubit(ProductsRepo());
  final SuppliersCubit suppliersCubit = SuppliersCubit(SuppliersRepo());
  final SelectedSupplierCubit selectedSupplierCubit = SelectedSupplierCubit();

  final supplierController = TextEditingController();
  final amountChargedController = TextEditingController();
  final amountPaidController = TextEditingController();
  SuppliersModelRow? selected;

  final supplierKey = 'supplySupplier';
  final amountChargedKey = 'supplyAmountCharged';
  final amountPaidKey = 'supplyAmountPaid';

  addSupply(bool isEdit) async {
    double amountCharged = double.parse(amountChargedController.text);
    double amountPaid = double.parse(amountPaidController.text);
    Map<String, dynamic> data = {
      'supplierId':
          isEdit ? widget.data!.supplierId : selectedSupplierCubit.state!.id,
      'amountCharged': amountCharged,
      'amountPaid': amountPaid,
      "supplyItems": selectedSupplyCubit.state
    };
    isEdit
        ? suppliesCubit.editSupply(
            widget.data!.id!,
            data,
          )
        : suppliesCubit.addSupply(data);
  }

  setDatafields() async {
    await productsCubit.getProducts();
    await suppliersCubit.getSuppliers();
    formValidationCubit.resetState();
    if (widget.data != null) {
      selected = SuppliersModelRow(
        id: widget.data!.id!,
        businessId: widget.data!.businessId!,
        userId: widget.data!.supplierId!,
        name: widget.data!.supplier!.name!,
        email: widget.data!.supplier!.email,
        phone: widget.data!.supplier!.phone,
        description: widget.data!.supplier!.description!,
        imageId: widget.data!.supplier!.imageId!,
        imageUrl: widget.data!.supplier!.imageUrl,
        createdAt: widget.data!.createdAt,
        updatedAt: widget.data!.updatedAt!,
      );
      for (var element in widget.data!.supplyItems!) {
        selectedSupplyCubit.addProduct(
          SupplyProduct(
            productId: element.productId!,
            supplyPrice: element.supplyPrice!,
            quantity: element.quantity!.toString(),
            productName: element.product!.name!,
          ),
        );
      }
      supplierController.text = selected!.name!;
      amountChargedController.text =
          amountChargedController.text = widget.data!.amountCharged!;

      amountPaidController.text = widget.data!.amountPaid!;
      setState(() {});
    }
    // formValidationCubit.validateField(supplierKey, widget.data != null);
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
    supplierController.clear();
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
            widget.data == null ? 'Add Supply' : 'Edit Supply',
          ),
        ),
        body: BlocConsumer<SuppliesCubit, SuppliesState>(
          bloc: suppliesCubit,
          listener: (context, state) {
            if (state is SuppliesAdded) {
              showSuccess(context, 'Good job, supply added successfully');
              Navigator.pop(context, true);
            } else if (state is SuppliesError) {
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
            }
            return BlocBuilder<ProductsCubit, ProductsState>(
              bloc: productsCubit,
              builder: (context, productsState) {
                if (productsState is ProductsLoading) {
                  return SpinKitWave(
                    itemBuilder: (BuildContext context, int index) {
                      return const DecoratedBox(
                        decoration: BoxDecoration(
                          color: ColorName.primaryColor,
                        ),
                      );
                    },
                  );
                } else if (productsState is ProductsLoaded) {
                  var products = productsState.data;
                  return BlocBuilder<FormValidationCubit, Map<String, bool>>(
                    bloc: formValidationCubit,
                    builder: (context, state) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 15.w,
                            right: 15.w,
                            top: 15.h,
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
                                    'Select Supplier',
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  widget.data != null
                                      ? CustomTextField(
                                          controller: supplierController,
                                          formValidationCubit:
                                              formValidationCubit,
                                          readOnly: true,
                                          fieldId: '',
                                          fillColor: ColorName.textfieldColor,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }

                                            return null;
                                          },
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
                                                        SuppliersCubit,
                                                        SuppliersState>(
                                                      bloc: suppliersCubit,
                                                      builder:
                                                          (context, state) {
                                                        if (state
                                                            is SuppliersLoaded) {
                                                          return BlocBuilder<
                                                              SelectedSupplierCubit,
                                                              SuppliersModelRow?>(
                                                            bloc:
                                                                selectedSupplierCubit,
                                                            builder: (context,
                                                                selectedState) {
                                                              final selectedEmployee =
                                                                  selectedSupplierCubit
                                                                      .state;
                                                              final selectedCategoryName =
                                                                  selectedEmployee
                                                                          ?.name ??
                                                                      'Select Supplier';
                                                              return DropdownButtonHideUnderline(
                                                                child: DropdownButton<
                                                                    SuppliersModelRow>(
                                                                  value:
                                                                      selectedEmployee,
                                                                  items: state.data.map<
                                                                      DropdownMenuItem<
                                                                          SuppliersModelRow>>(
                                                                    (SuppliersModelRow
                                                                        category) {
                                                                      return DropdownMenuItem<
                                                                          SuppliersModelRow>(
                                                                        value:
                                                                            category,
                                                                        child:
                                                                            Text(
                                                                          category.name ??
                                                                              '',
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                ColorName.blackColor,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).toList(),
                                                                  onChanged:
                                                                      (SuppliersModelRow?
                                                                          newValue) {
                                                                    selectedSupplierCubit
                                                                        .setSelectedCategory(
                                                                            newValue);
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .arrow_drop_down,
                                                                      color: ColorName
                                                                          .blackColor),
                                                                  iconSize: 24,
                                                                  isExpanded:
                                                                      true,
                                                                  underline:
                                                                      const SizedBox(),
                                                                  hint: Text(
                                                                    selectedCategoryName,
                                                                    style:
                                                                        TextStyle(
                                                                      color: ColorName
                                                                          .mainGrey,
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
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
                                    child: BlocBuilder<SelectedSupplyCubit,
                                        List<SupplyProduct>>(
                                      bloc: selectedSupplyCubit,
                                      builder: (context, selectedSupplyState) {
                                        if (selectedSupplyState.isEmpty) {
                                          return Center(
                                            child: AppText.medium(
                                              'Please add an item',
                                            ),
                                          );
                                        }
                                        return ListView.builder(
                                          itemCount: selectedSupplyState.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var item =
                                                selectedSupplyState[index];
                                            return Container(
                                              padding: EdgeInsets.all(8.h),
                                              margin: EdgeInsets.symmetric(
                                                vertical: 3.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: ColorName.whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20,
                                                ),
                                              ),
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
                                                        'Ksh: ${item.supplyPrice}',
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        selectedSupplyCubit
                                                            .removeProduct(
                                                      item,
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    ),
                                                  )
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
                                              builder: (BuildContext context) {
                                                return CenterPopup(
                                                  data: products,
                                                  selectedSupplyCubit:
                                                      selectedSupplyCubit,
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
                                  BlocBuilder<SelectedSupplyCubit,
                                      List<SupplyProduct>>(
                                    bloc: selectedSupplyCubit,
                                    builder: (context, state) {
                                      amountChargedController.text =
                                          selectedSupplyCubit
                                              .getTotalPrice()
                                              .toString();
                                      amountChargedController.text != '0.0'
                                          ? formValidationCubit.validateField(
                                              amountChargedKey,
                                              true,
                                            )
                                          : null;
                                      return CustomTextField(
                                        controller: amountChargedController,
                                        formValidationCubit:
                                            formValidationCubit,
                                        fieldId: amountChargedKey,
                                        fillColor: ColorName.textfieldColor,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
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
        bottomNavigationBar:
            BlocBuilder<FormValidationCubit, Map<String, bool>>(
          bloc: formValidationCubit,
          builder: (context, state) {
            bool isFormValid = formValidationCubit.isFormValid();
            return Container(
              margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
              width: 300.w,
              height: 50,
              child: CustomButton(
                onTap: isFormValid &&
                        selectedSupplierCubit.state != null &&
                        selectedSupplyCubit.state.isNotEmpty
                    ? () async {
                        await addSupply(false);
                      }
                    : isFormValid &&
                            widget.data != null &&
                            selectedSupplyCubit.state.isNotEmpty
                        ? () async {
                            await addSupply(true);
                          }
                        : () {},
                text: 'Submit',
                color: isFormValid && selectedSupplyCubit.state.isNotEmpty
                    ? ColorName.primaryColor
                    : ColorName.mainGrey,
                radius: 20,
                fontWeight: FontWeight.normal,
                textColor: isFormValid && selectedSupplyCubit.state.isNotEmpty
                    ? ColorName.whiteColor
                    : ColorName.lightGrey,
              ),
            );
          },
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
        //         onTap: isFormValid && selectedSupplierCubit.state != null
        //             ? widget.data == null
        //                 ? () async {
        //                     await addSupply(false);
        //                   }
        //                 : () async {
        //                     await addSupply(true);
        //                   }
        //             : () {},
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
      {super.key, required this.data, required this.selectedSupplyCubit});

  final List<ProductsModelRow> data;
  final SelectedSupplyCubit selectedSupplyCubit;

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

  final prodQuantityKey = 'supplyProdQuantity';
  final prodPriceKey = 'supplyProdPrice';

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
                      prodQuantityKey,
                      value.isNotEmpty,
                    );

                    final enteredQuantity = double.tryParse(value) ?? 0;
                    final buyingPrice = double.tryParse(
                            productsCubit.selectedProduct!.buyingPrice!) ??
                        0.0;

                    // Update the price field
                    final calculatedPrice = enteredQuantity * buyingPrice;
                    productPriceController.text =
                        calculatedPrice.toStringAsFixed(2);

                    formValidationCubit.validateField(
                      prodPriceKey,
                      value.isNotEmpty,
                    );

                    subTotalCubit.updateProduct(
                      double.tryParse(value) ?? 0,
                      double.tryParse(productPriceController.text) ?? 0,
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
                              widget.selectedSupplyCubit.addProduct(
                                SupplyProduct(
                                  productId: productsCubit.selectedProduct!.id!,
                                  productName:
                                      productsCubit.selectedProduct!.name!,
                                  supplyPrice: subTotalCubit.state.toString(),
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
