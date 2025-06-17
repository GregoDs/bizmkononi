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
import '../../../utils/widgets/custom_textfield.dart';

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
        id: widget.data!.supplier!.id!,
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
      selectedSupplierCubit.setSelectedCategory(selected);
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
      supplierController.text = widget.data!.supplier!.name!;
      amountChargedController.text = widget.data!.amountCharged!;
      amountPaidController.text = widget.data!.amountPaid!;
      setState(() {});
    }
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
          backgroundColor: ColorName.primaryColor,
          centerTitle: true,
          title: AppText.medium(
            widget.data == null ? 'Add Supply' : 'Edit Supply',
            color: ColorName.whiteColor,
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
                                    widget.data != null
                                        ? 'Supplier'
                                        : 'Select Supplier',
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  widget.data != null
                                      ? ServicesTextField(
                                          controller: TextEditingController(
                                              text:
                                                  widget.data!.supplier!.name!),
                                          formValidationCubit:
                                              formValidationCubit,
                                          readOnly: true,
                                          fieldId: '',
                                          fillColor: ColorName.lightGrey,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a text';
                                            }
                                            return null;
                                          },
                                          prefixIcon: const Icon(Icons.person,
                                              color: ColorName.blue200),
                                          borderRadius: 12,
                                          isPassword: false,
                                          label: null,
                                          suffixIcon: const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Text('',
                                                style: TextStyle(
                                                    color:
                                                        ColorName.whiteColor)),
                                          ),
                                        )
                                      : BlocBuilder<SuppliersCubit,
                                          SuppliersState>(
                                          bloc: suppliersCubit,
                                          builder: (context, state) {
                                            if (state is SuppliersLoaded) {
                                              return BlocBuilder<
                                                  SelectedSupplierCubit,
                                                  SuppliersModelRow?>(
                                                bloc: selectedSupplierCubit,
                                                builder:
                                                    (context, selectedState) {
                                                  return ServicesDropdownField<
                                                      SuppliersModelRow>(
                                                    value: selectedSupplierCubit
                                                        .state,
                                                    items: state.data.map<
                                                            DropdownMenuItem<
                                                                SuppliersModelRow>>(
                                                        (SuppliersModelRow
                                                            category) {
                                                      return DropdownMenuItem<
                                                          SuppliersModelRow>(
                                                        value: category,
                                                        child: Text(
                                                            category.name ?? '',
                                                            style: const TextStyle(
                                                                color: ColorName
                                                                    .blackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal)),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (SuppliersModelRow?
                                                            newValue) {
                                                      selectedSupplierCubit
                                                          .setSelectedCategory(
                                                              newValue);
                                                    },
                                                    hintText: 'Select Supplier',
                                                    prefixIcon: const Icon(
                                                        Icons.person,
                                                        color:
                                                            ColorName.blue200),
                                                    fillColor:
                                                        ColorName.lightGrey,
                                                    borderRadius: 12,
                                                  );
                                                },
                                              );
                                            } else {
                                              return SpinKitWave(
                                                size: 20,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return const DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: ColorName
                                                          .primaryColor,
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  AppText.medium(
                                    'Selected Products',
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: 5.h),
                                  Container(
                                    height: 220,
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6F8FB),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: BlocBuilder<SelectedSupplyCubit,
                                        List<SupplyProduct>>(
                                      bloc: selectedSupplyCubit,
                                      builder: (context, selectedSupplyState) {
                                        if (selectedSupplyState.isEmpty) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/emptyData.png',
                                                  width: 140,
                                                  height: 140,
                                                  fit: BoxFit.contain,
                                                ),
                                                const SizedBox(height: 16),
                                                AppText.medium(
                                                  'Please add an item',
                                                  color: const Color(
                                                      0xFF2B4B6A),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
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
                                              padding: EdgeInsets.all(12),
                                              margin: EdgeInsets.symmetric(
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  16,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.07),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
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
                                                        width: 20,
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
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        width: 180,
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
                                          fontSize: 15,
                                          radius: 20,
                                          color: ColorName.blue200,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
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
                                                  amountChargedController
                                                              .text !=
                                                          '0.0'
                                                      ? formValidationCubit
                                                          .validateField(
                                                          amountChargedKey,
                                                          true,
                                                        )
                                                      : null;
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFBDBDBD)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: ServicesTextField(
                                                      controller:
                                                          amountChargedController,
                                                      formValidationCubit:
                                                          formValidationCubit,
                                                      fieldId: amountChargedKey,
                                                      fillColor:
                                                          ColorName.lightGrey,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter amount charged.';
                                                        }
                                                        return null;
                                                      },
                                                      prefixIcon: const Icon(
                                                          Icons.attach_money,
                                                          color: ColorName
                                                              .blue200),
                                                      borderRadius: 12,
                                                      isPassword: false,
                                                      label: null,
                                                      readOnly: false,
                                                      suffixIcon: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.0),
                                                        child: Text('Kshs',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey)),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText.medium(
                                              'Amount Paid',
                                              color: Colors.black,
                                            ),
                                            SizedBox(height: 5.h),
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 800),
                                              curve: Curves.easeInOut,
                                              decoration: BoxDecoration(
                                                color: ColorName.lightGrey,
                                                border: Border.all(
                                                  color: Colors.greenAccent
                                                      .withOpacity(0.7),
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.greenAccent
                                                        .withOpacity(0.3),
                                                    blurRadius: 12,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: ServicesTextField(
                                                controller:
                                                    amountPaidController,
                                                formValidationCubit:
                                                    formValidationCubit,
                                                fieldId: amountPaidKey,
                                                fillColor: ColorName.lightGrey,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter amount paid';
                                                  }
                                                  return null;
                                                },
                                                prefixIcon: const Icon(
                                                    Icons.payments,
                                                    color: ColorName.blue200),
                                                borderRadius: 12,
                                                isPassword: false,
                                                label: null,
                                                readOnly: false,
                                                suffixIcon: const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Text('Kshs',
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  AppText.medium('Balance to be Paid',
                                      color: Colors.black),
                                  SizedBox(height: 5.h),
                                  Container(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xFFBDBDBD)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ServicesTextField(
                                      controller: TextEditingController(
                                        text:
                                            'Kshs ${(double.tryParse(amountPaidController.text) ?? 0) - (double.tryParse(amountChargedController.text) ?? 0)}',
                                      ),
                                      formValidationCubit: formValidationCubit,
                                      fieldId: 'balanceField',
                                      fillColor: ColorName.lightGrey,
                                      readOnly: true,
                                      prefixIcon: const Icon(
                                          Icons.account_balance_wallet,
                                          color: ColorName.blue200),
                                      borderRadius: 12,
                                      isPassword: false,
                                      label: null,
                                      suffixIcon: const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Text('Kshs',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                  ),
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
              margin: EdgeInsets.only(bottom: 26.h, left: 20.w, right: 20.w),
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
                            selectedSupplyCubit.state.isNotEmpty &&
                            amountPaidController.text.isNotEmpty
                        ? () async {
                            await addSupply(true);
                          }
                        : () {},
                text: 'Submit',
                color: isFormValid &&
                        selectedSupplyCubit.state.isNotEmpty &&
                        (widget.data == null ||
                            (widget.data != null &&
                                amountPaidController.text.isNotEmpty))
                    ? ColorName.primaryColor
                    : ColorName.mainGrey,
                radius: 20,
                fontWeight: FontWeight.normal,
                textColor: isFormValid &&
                        selectedSupplyCubit.state.isNotEmpty &&
                        (widget.data == null ||
                            (widget.data != null &&
                                amountPaidController.text.isNotEmpty))
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
                PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8), // Adjust the radius here
                    child: AppBar(
                      leading: const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                      ),
                      elevation: 0,
                      backgroundColor: ColorName.primaryColor,
                      title: AppText.medium(
                        'Product Details',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      centerTitle: true,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                AppText.medium(
                  'Product Name',
                  color: Colors.black,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(50),
                  padding: const EdgeInsets.only(left: 10),
                  // decoration: BoxDecoration(
                  //   color: ColorName.textfieldColor,
                  //   borderRadius: BorderRadius.circular(8.0),
                  //   border: Border.all(color: ColorName.blackColor),
                  // ),
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: BlocBuilder<ProductsCubit, ProductsState>(
                        bloc: productsCubit,
                        builder: (context, state) =>
                            ServicesDropdownField<ProductsModelRow>(
                          value: productsCubit.selectedProduct,
                          items: widget.data
                              .map<DropdownMenuItem<ProductsModelRow>>(
                                  (ProductsModelRow product) {
                            return DropdownMenuItem<ProductsModelRow>(
                              value: product,
                              child: Text(product.name!,
                                  style: TextStyle(
                                      color: ColorName.blackColor,
                                      fontSize: 14.sp)),
                            );
                          }).toList(),
                          onChanged: (ProductsModelRow? newValue) {
                            productsCubit.setSelectedProduct(newValue!);
                            productPriceController.text =
                                newValue.buyingPrice ?? '';
                            subTotalCubit.updateProduct(
                              double.tryParse(productQuantityController.text) ??
                                  0,
                              double.tryParse(newValue.buyingPrice ?? '0') ?? 0,
                            );
                          },
                          hintText: 'Select Product',
                          prefixIcon: const Icon(Icons.shopping_cart,
                              color: ColorName.blue200),
                          fillColor: ColorName.lightGrey,
                          borderRadius: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.medium(
                            'Quantity',
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          ServicesTextField(
                            controller: productQuantityController,
                            formValidationCubit: formValidationCubit,
                            fieldId: prodQuantityKey,
                            fillColor: ColorName.lightGrey,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter quantity';
                              }
                              return null;
                            },
                            prefixIcon: const Icon(Icons.shopping_bag,
                                color: ColorName.blue200),
                            borderRadius: 12,
                            isPassword: false,
                            label: null,
                            keyboardType: TextInputType.number,
                            onChanged: (value) async {
                              formValidationCubit.validateField(
                                  prodQuantityKey, value.isNotEmpty);
                              subTotalCubit.updateProduct(
                                double.tryParse(value) ?? 0,
                                double.tryParse(productPriceController.text) ??
                                    0,
                              );
                            },
                            readOnly: false,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text('',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.medium(
                            'Unit Price',
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          ServicesTextField(
                            controller: productPriceController,
                            formValidationCubit: formValidationCubit,
                            fieldId: prodPriceKey,
                            fillColor: ColorName.lightGrey,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price';
                              }
                              return null;
                            },
                            prefixIcon: const Icon(Icons.attach_money,
                                color: ColorName.blue200),
                            borderRadius: 12,
                            isPassword: false,
                            label: null,
                            keyboardType: TextInputType.number,
                            onChanged: (value) async {
                              formValidationCubit.validateField(
                                  prodPriceKey, value.isNotEmpty);
                              subTotalCubit.updateProduct(
                                double.tryParse(
                                        productQuantityController.text) ??
                                    0,
                                double.tryParse(value) ?? 0,
                              );
                            },
                            readOnly: false,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text(
                                  'Kshs',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 9,  
                                  ),
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                              final unitPrice = double.tryParse(productPriceController.text) ?? 0;
                              final qty = int.tryParse(productQuantityController.text) ?? 0;
                              final total = (unitPrice * qty).toStringAsFixed(2);

                              widget.selectedSupplyCubit.addProduct(
                                SupplyProduct(
                                  productId: productsCubit.selectedProduct!.id!,
                                  productName: productsCubit.selectedProduct!.name!,
                                  supplyPrice: productPriceController.text, // unit price
                                  quantity: productQuantityController.text,
                                  totalAmount: total,
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
                                : ColorName.primaryColor,
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
