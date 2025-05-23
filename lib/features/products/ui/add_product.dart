import 'package:biz_mkononi/features/products/cubit/products_cubit.dart';
import 'package:biz_mkononi/features/products/repo/products_repo.dart';
import 'package:biz_mkononi/utils/functions/functions.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';
import '../../categories/cubit/category_cubit.dart';
import '../../categories/models/category_model.dart';
import '../../categories/repo/categories_repo.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key, this.data});
  final ProductsModelRow? data;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final ProductsCubit productsCubit = ProductsCubit(ProductsRepo());
  final ProductTypeCubit productTypeCubit = ProductTypeCubit();
  final ImagePickerCubit imagePickerCubit = ImagePickerCubit();
  final CategoryCubit categoryCubit = CategoryCubit(CategoriesRepo());
  final selectedCategoryCubit = SelectedCategoryCubit();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final typeController = TextEditingController();
  final sizeController = TextEditingController();
  final unitController = TextEditingController();
  final descrController = TextEditingController();
  final bpController = TextEditingController();
  final spController = TextEditingController();
  final tagsController = TextEditingController();
  String? categoryId;

  final nameKey = 'productName';
  final categoryKey = 'productCategory';
  final typeKey = 'productType';
  final sizeKey = 'productSize';
  final unitKey = 'productUnit';
  final descrKey = 'productDesr';
  final bpKey = 'productBp';
  final spKey = 'productSp';
  final tagsKey = 'productTags';

  int getYearOfBirthFromString(String ageString) {
    // Parse the age string to an integer
    int age = int.tryParse(ageString) ?? 0; // Default to 0 if parsing fails

    // Get the current year
    int currentYear = DateTime.now().year;

    // Calculate the year of birth
    int yearOfBirth = currentYear - age;

    return yearOfBirth;
  }

  String formatString(String input) {
    // Trim leading and trailing spaces
    String trimmedInput = input.trim();

    // Capitalize the first letter
    String formattedString =
        trimmedInput.substring(0, 1).toUpperCase() + trimmedInput.substring(1);

    return formattedString;
  }

  addCustomer(bool isEdit) async {
    Map<String, dynamic> data = {
      'name': formatString(nameController.text),
      'categoryName': selectedCategoryCubit.state!.name,
      'categoryId': selectedCategoryCubit.state!.id,
      'description': descrController.text,
      'size': sizeController.text,
      'unit': unitController.text,
      'buyingPrice': bpController.text,
      'sellingPrice': spController.text,
      'tags': tagsController.text,
      'productType': productTypeCubit.state.name,
    };
    isEdit
        ? productsCubit.editProduct(
            widget.data!.id!,
            data,
          )
        : productsCubit.addProduct(
            data,
          );
  }

  setDatafields() async {
    categoryCubit.getCategories();
    formValidationCubit.resetState();
    if (widget.data != null) {
      nameController.text = widget.data!.name!;
      sizeController.text = widget.data!.size.toString();
      unitController.text = widget.data!.unit!;
      descrController.text = widget.data!.description!;
      bpController.text = widget.data!.buyingPrice!;
      spController.text = widget.data!.sellingPrice!;
      tagsController.text = widget.data!.tags!;
      typeController.text = widget.data!.productType!;
      if (widget.data!.productType! == 'SERVICE') {
        productTypeCubit.setProductType(ProductType.PRODUCT);
      } else if (widget.data!.productType! == 'PRODUCT') {
        productTypeCubit.setProductType(ProductType.PRODUCT);
      }
    }
    formValidationCubit.validateField(nameKey, widget.data != null);
    formValidationCubit.validateField(categoryKey, widget.data != null);
    formValidationCubit.validateField(typeKey, widget.data != null);
    formValidationCubit.validateField(sizeKey, widget.data != null);
    formValidationCubit.validateField(unitKey, widget.data != null);
    formValidationCubit.validateField(descrKey, widget.data != null);
    formValidationCubit.validateField(bpKey, widget.data != null);
    formValidationCubit.validateField(spKey, widget.data != null);
    formValidationCubit.validateField(tagsKey, widget.data != null);
  }

  @override
  void initState() {
    setDatafields();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.clear();
    categoryController.clear();
    typeController.clear();
    sizeController.clear();
    unitController.clear();
    descrController.clear();
    bpController.clear();
    spController.clear();
    tagsController.clear();
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
            widget.data == null ? 'Add Product' : 'Edit Product',
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<ProductsCubit, ProductsState>(
            bloc: productsCubit,
            listener: (context, state) {
              if (state is ProductsAdded) {
                showSuccess(context, 'Good job, changes made Successfully');
                Navigator.pop(context, true);
              } else if (state is ProductsError) {
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
              if (state is ProductsLoading) {
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Center(
                                child: CircleAvatar(
                                  radius: 38,
                                  backgroundColor:
                                      ColorName.primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.shopping_bag,
                                    size: 48,
                                    color: ColorName.primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Center(
                                child: AppText.medium(
                                  widget.data == null
                                      ? 'Add Product'
                                      : 'Edit Product',
                                  color: ColorName.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Divider(thickness: 1, color: ColorName.lightGrey),
                              SizedBox(height: 10.h),
                              AppText.medium(
                                'Name',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: nameController,
                                formValidationCubit: formValidationCubit,
                                fieldId: nameKey,
                                fillColor: ColorName.textfieldColor,
                                validator:
                                    Functions().noSpecialCharactersValidator,
                                prefixIcon: Icon(Icons.shopping_bag,
                                    color: ColorName.primaryColor),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Category',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.category,
                                      color: ColorName.primaryColor),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      width: ScreenUtil().screenWidth,
                                      height: ScreenUtil().setHeight(50),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: ColorName.textfieldColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: ColorName.blackColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: BlocBuilder<CategoryCubit,
                                                    CategoryState>(
                                                  bloc: categoryCubit,
                                                  builder: (context, state) {
                                                    if (state
                                                        is CategoriesLoaded) {
                                                      return BlocBuilder<
                                                          SelectedCategoryCubit,
                                                          CategoryModelRow?>(
                                                        bloc:
                                                            selectedCategoryCubit,
                                                        builder: (context,
                                                            selectedState) {
                                                          final selectedCategory =
                                                              selectedCategoryCubit
                                                                  .state;
                                                          final selectedCategoryName =
                                                              selectedCategory
                                                                      ?.name ??
                                                                  'Select Category';
                                                          return DropdownButtonHideUnderline(
                                                            child: DropdownButton<
                                                                CategoryModelRow>(
                                                              value:
                                                                  selectedCategory,
                                                              items: state.data.map<
                                                                  DropdownMenuItem<
                                                                      CategoryModelRow>>(
                                                                (CategoryModelRow
                                                                    category) {
                                                                  return DropdownMenuItem<
                                                                      CategoryModelRow>(
                                                                    value:
                                                                        category,
                                                                    child: Text(
                                                                      category
                                                                              .name ??
                                                                          '',
                                                                      style:
                                                                          const TextStyle(
                                                                        color: ColorName
                                                                            .blackColor,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  );
                                                                },
                                                              ).toList(),
                                                              onChanged:
                                                                  (CategoryModelRow?
                                                                      newValue) {
                                                                selectedCategoryCubit
                                                                    .setSelectedCategory(
                                                                  newValue,
                                                                );
                                                                formValidationCubit
                                                                    .validateField(
                                                                        categoryKey,
                                                                        true);
                                                              },
                                                              icon: const Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  color: ColorName
                                                                      .blackColor),
                                                              iconSize: 24,
                                                              isExpanded: true,
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
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
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
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Product Type',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                width: ScreenUtil().screenWidth,
                                height: ScreenUtil()
                                    .setHeight(50), // Convert 50 to cubic value
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: ColorName.textfieldColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border:
                                      Border.all(color: ColorName.blackColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: Center(
                                    child: BlocBuilder<ProductTypeCubit,
                                        ProductType>(
                                      bloc: productTypeCubit,
                                      builder: (context, state) =>
                                          DropdownButtonFormField<String>(
                                        decoration:
                                            const InputDecoration.collapsed(
                                                hintText: ''),
                                        value: state == ProductType.SERVICE
                                            ? 'SERVICE'
                                            : state == ProductType.PRODUCT
                                                ? 'PRODUCT'
                                                : 'Please Select Type',
                                        hint: AppText.small(
                                          'Product Type',
                                          color: ColorName.mainGrey,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        items: <String>[
                                          'Please Select Type',
                                          'SERVICE',
                                          'PRODUCT',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: value ==
                                                        'Please Select Type'
                                                    ? ColorName.mainGrey
                                                    : Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          formValidationCubit.validateField(
                                              typeKey, true);
                                          if (newValue ==
                                              'Please Select Type') {
                                            productTypeCubit.setProductType(
                                                ProductType.SERVICE);
                                          } else if (newValue == 'SERVICE') {
                                            productTypeCubit.setProductType(
                                                ProductType.PRODUCT);
                                          } else if (newValue == 'PRODUCT') {
                                            productTypeCubit.setProductType(
                                                ProductType.PRODUCT);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Size',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: sizeController,
                                formValidationCubit: formValidationCubit,
                                fieldId: sizeKey,
                                keyboardType: TextInputType.number,
                                fillColor: ColorName.textfieldColor,
                                validator:
                                    Functions().noSpecialCharactersValidator,
                                prefixIcon: Icon(Icons.straighten,
                                    color: ColorName.primaryColor),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Unit e.g. ml for milliliters',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: unitController,
                                formValidationCubit: formValidationCubit,
                                fieldId: unitKey,
                                fillColor: ColorName.textfieldColor,
                                validator:
                                    Functions().noSpecialCharactersValidator,
                                prefixIcon: Icon(Icons.line_weight,
                                    color: ColorName.primaryColor),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Description (Optional)',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              TextFormField(
                                maxLines: 5,
                                controller: descrController,
                                keyboardType: TextInputType.multiline,
                                validator:
                                    Functions().noSpecialCharactersValidator,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                onChanged: (value) {
                                  formValidationCubit.validateField(
                                      descrKey, value.isNotEmpty);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.description,
                                      color: ColorName.primaryColor),
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
                                    borderSide: const BorderSide(
                                      color: ColorName.lightGrey,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: ColorName.lightGrey,
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: ColorName.blackColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Buying Price e.g 1000(Optional)',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: bpController,
                                formValidationCubit: formValidationCubit,
                                fieldId: bpKey,
                                keyboardType: TextInputType.number,
                                fillColor: ColorName.textfieldColor,
                                validator:
                                    Functions().noSpecialCharactersValidator,
                                prefixIcon: Icon(Icons.attach_money,
                                    color: ColorName.primaryColor),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Selling Price e.g 1000',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: spController,
                                formValidationCubit: formValidationCubit,
                                fieldId: spKey,
                                keyboardType: TextInputType.number,
                                fillColor: ColorName.textfieldColor,
                                validator:
                                    Functions().noSpecialCharactersValidator,
                                prefixIcon: Icon(Icons.attach_money,
                                    color: ColorName.primaryColor),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Tags (Optional)',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: tagsController,
                                formValidationCubit: formValidationCubit,
                                fieldId: tagsKey,
                                fillColor: ColorName.textfieldColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }

                                  return null;
                                },
                                prefixIcon: Icon(Icons.label,
                                    color: ColorName.primaryColor),
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
            },
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<FormValidationCubit, Map<String, bool>>(
          bloc: formValidationCubit,
          builder: (context, state) {
            bool isFormValid = formValidationCubit.isFormValid();
            String seletedType = productTypeCubit.state.name;
            return Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
              width: 300.w,
              height: 50,
              child: CustomButton(
                onTap: isFormValid && seletedType != 'Please Select Type'
                    ? () async {
                        await addCustomer(false);
                      }
                    : isFormValid &&
                            seletedType != 'Please Select Type' &&
                            widget.data != null
                        ? () async {
                            await addCustomer(true);
                          }
                        : () {},
                text: 'Submit',
                color: isFormValid && seletedType != 'Please Select Type' ||
                        isFormValid &&
                            seletedType != 'Please Select Type' &&
                            widget.data != null
                    ? ColorName.primaryColor
                    : ColorName.mainGrey,
                radius: 20,
                fontWeight: FontWeight.normal,
                textColor: isFormValid && seletedType != 'Please Select Type' ||
                        isFormValid &&
                            seletedType != 'Please Select Type' &&
                            widget.data != null
                    ? ColorName.whiteColor
                    : ColorName.lightGrey,
              ),
            );
          },
        ),
      ),
    );
  }
}
