import 'package:biz_mkononi/features/businesses/ui/location_field.dart';
import 'package:biz_mkononi/utils/functions/functions.dart';
import 'package:flutter/services.dart';
import '../../../exports.dart';

class AddBusiness extends StatefulWidget {
  const AddBusiness({super.key, this.data});
  final BusinessModelRows? data;

  @override
  State<AddBusiness> createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  BusinessesCubit businessesCubit = BusinessesCubit(BusinessesRepo());
  final ProductTypeCubit productTypeCubit = ProductTypeCubit();
  final ImagePickerCubit imagePickerCubit = ImagePickerCubit();

  final nameController = TextEditingController();
  // final typeController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descrController = TextEditingController();

  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final locationDetailsController = TextEditingController();
  final locController = TextEditingController();

  final nameKey = 'businessName';
  final typeKey = 'businessType';
  final emailKey = 'businessEmail';
  final phoneKey = 'businessPhone';
  final descrKey = 'businessDescr';
  final latKey = 'businessLat';
  final longKey = 'businessLong';
  final locKey = 'businessLocation';
  final locDescr = 'businessLocDescr';

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
      'productType': productTypeCubit.state.name,
      'businessEmail': emailController.text,
      'businessPhone': phoneController.text,
      'description': descrController.text,
      'latitude': 123456,
      'longitude': 536277,
      'locationDetails': locationDetailsController.text,
      'location': locController.text,
    };
    isEdit
        ? businessesCubit.editBusiness(
            widget.data!.id!,
            data,
          )
        : businessesCubit.addBusiness(
            data,
          );
  }

  setDatafields() async {
    formValidationCubit.resetState();
    if (widget.data != null) {
      nameController.text = widget.data!.name!;
      // typeController.text = widget.data!.productType!;
      emailController.text = widget.data!.businessEmail!;
      phoneController.text = widget.data!.businessPhone!;
      descrController.text = widget.data!.description!;
      latitudeController.text = widget.data!.latitude.toString();
      longitudeController.text = widget.data!.longitude.toString();
      locationDetailsController.text = widget.data!.locationDetails!;
      locController.text = widget.data!.location!;
      if (widget.data!.productType! == 'SERVICE') {
        productTypeCubit.setProductType(ProductType.PRODUCT);
      } else if (widget.data!.productType! == 'PRODUCT') {
        productTypeCubit.setProductType(ProductType.PRODUCT);
      } else if (widget.data!.productType! == 'SERVICE_PRODUCT') {
        productTypeCubit.setProductType(ProductType.SERVICE_PRODUCT);
      }
    }
    formValidationCubit.validateField(nameKey, widget.data != null);
    // formValidationCubit.validateField(typeKey, widget.data != null);
    formValidationCubit.validateField(emailKey, widget.data != null);
    formValidationCubit.validateField(phoneKey, widget.data != null);
    formValidationCubit.validateField(descrKey, widget.data != null);
    // formValidationCubit.validateField(latKey, widget.data != null);
    // formValidationCubit.validateField(longKey, widget.data != null);
    formValidationCubit.validateField(locKey, widget.data != null);
    formValidationCubit.validateField(locDescr, widget.data != null);
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
    emailController.clear();
    phoneController.clear();
    descrController.clear();
    latitudeController.clear();
    longitudeController.clear();
    locationDetailsController.clear();
    locController.clear();
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
            widget.data == null ? 'Add Business' : 'Edit Business',
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<BusinessesCubit, BusinessesState>(
            bloc: businessesCubit,
            listener: (context, state) {
              if (state is BusinessesAdded) {
                showSuccess(context, 'Good job, changes made Successfully');
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              } else if (state is BusinessesError) {
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
              if (state is BusinessesLoading) {
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
                          left: 15.w, right: 15.w, top: 15.h, bottom: 80.h),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorName.whiteColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Business Name',
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid business name';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Business Email',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: emailController,
                                formValidationCubit: formValidationCubit,
                                fieldId: emailKey,
                                keyboardType: TextInputType.emailAddress,
                                fillColor: ColorName.textfieldColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Business email';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Business Phone',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: phoneController,
                                formValidationCubit: formValidationCubit,
                                fieldId: phoneKey,
                                keyboardType: TextInputType.phone,
                                fillColor: ColorName.textfieldColor,
                                validator: (value) =>
                                    Functions().combineValidators(value, [
                                  Functions().noSpecialCharactersValidator,
                                  Functions().phoneNumberValidator,
                                ]),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Business Location',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              LocationAutoComplete(
                                controller: locController,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Location Details',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: locationDetailsController,
                                formValidationCubit: formValidationCubit,
                                fieldId: locDescr,
                                fillColor: ColorName.textfieldColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter location details';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Business Type',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                width: ScreenUtil().screenWidth,
                                height: ScreenUtil().setHeight(50),
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
                                          hintText: '',
                                        ),
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
                                          'SERVICE_PRODUCT',
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
                                          } else if (newValue ==
                                              'SERVICE_PRODUCT') {
                                            productTypeCubit.setProductType(
                                                ProductType.SERVICE_PRODUCT);
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
                                'Description',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              TextFormField(
                                maxLines: 5,
                                controller: descrController,
                                keyboardType: TextInputType.multiline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }

                                  return null;
                                },
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
                                height: 50.h,
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
        // floatingActionButton:
        //     BlocBuilder<FormValidationCubit, Map<String, bool>>(
        //   bloc: formValidationCubit,
        //   builder: (context, state) {
        //     bool isFormValid = formValidationCubit.isFormValid();
        //     String seletedType = productTypeCubit.state.name;
        //     return BlocBuilder<ImagePickerCubit, File?>(
        //       bloc: imagePickerCubit,
        //       builder: (context, imageState) {
        //         return Container(
        //           margin: EdgeInsets.only(bottom: 20.h),
        //           width: 300.w,
        //           child: CustomButton(
        //             onTap: isFormValid &&
        //                     seletedType != 'Please Select Type' &&
        //                     imageState != null
        //                 ? () async {
        //                         await addCustomer(false);
        //                       }
        //                       :
        //                 isFormValid &&
        //                     seletedType != 'Please Select Type' && widget.data != null
        //                     ?  () async {
        //                         await addCustomer(true);
        //                       }
        //                 : () {},
        //             text: 'Submit',
        //             color: isFormValid &&
        //                     seletedType != 'Please Select Type' &&
        //                     imageState != null || isFormValid &&
        //                     seletedType != 'Please Select Type' && widget.data != null
        //                 ? ColorName.primaryColor
        //                 : ColorName.mainGrey,
        //             radius: 20,
        //             fontWeight: FontWeight.normal,
        //             textColor: isFormValid &&
        //                     seletedType != 'Please Select Type' &&
        //                     imageState != null || isFormValid &&
        //                     seletedType != 'Please Select Type' && widget.data != null
        //                 ? ColorName.whiteColor
        //                 : ColorName.lightGrey,
        //           ),
        //         );
        //       },
        //     );
        //   },
        // ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }

  void imageDialog(BuildContext context) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: AppText.medium('Media Source'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    getImageDialog(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image),
                ),
                IconButton(
                  onPressed: () {
                    getImageDialog(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          );
        },
        context: context);
  }

  getImageDialog(ImageSource source) async {
    await imagePickerCubit.getImage(source);
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
