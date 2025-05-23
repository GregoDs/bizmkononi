import 'package:biz_mkononi/utils/functions/functions.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';
import '../cubit/suppliers_cubit.dart';
import '../models/suppliers_model.dart';
import '../repo/suppliers_repo.dart';

class AddSupplier extends StatefulWidget {
  const AddSupplier({super.key, this.data});
  final SuppliersModelRow? data;

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final SuppliersCubit suppliersCubit = SuppliersCubit(SuppliersRepo());
  final ProductTypeCubit productTypeCubit = ProductTypeCubit();
  final ImagePickerCubit imagePickerCubit = ImagePickerCubit();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descrController = TextEditingController();
  String? categoryId;

  @override
  void dispose() {
    super.dispose();
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    descrController.clear();
  }

  final nameKey = 'supplierName';
  final emailKey = 'supplierEmail';
  final phoneKey = 'supplierPhone';
  final descrKey = 'productDesr';

  addSupplier(bool isEdit) async {
    Map<String, dynamic> data = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'description': descrController.text,
    };
    isEdit
        ? suppliersCubit.editSupplier(
            widget.data!.id!,
            data,
          )
        : suppliersCubit.addSupplier(
            data,
          );
  }

  setDatafields() async {
    formValidationCubit.resetState();
    if (widget.data != null) {
      nameController.text = widget.data!.name!;
      emailController.text = widget.data!.email!;
      phoneController.text = widget.data!.phone!;
      descrController.text = widget.data!.description!;
    }
    formValidationCubit.validateField(nameKey, widget.data != null);
    formValidationCubit.validateField(emailKey, widget.data != null);
    formValidationCubit.validateField(phoneKey, widget.data != null);
    formValidationCubit.validateField(descrKey, widget.data != null);
  }

  @override
  void initState() {
    setDatafields();
    super.initState();
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
            widget.data == null ? 'Add Supplier' : 'Edit Supplier',
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<SuppliersCubit, SuppliersState>(
            bloc: suppliersCubit,
            listener: (context, state) {
              if (state is SuppliersAdded) {
                showSuccess(context, 'Good job, supplier added successfully');
                suppliersCubit.getSuppliers();
                Navigator.pop(context, true);
              } else if (state is SuppliersError) {
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
              if (state is SuppliersLoading) {
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Center(
                                child: CircleAvatar(
                                  radius: 38,
                                  backgroundColor:
                                      ColorName.primaryColor.withOpacity(0.1),
                                  child: Icon(Icons.local_shipping,
                                      size: 48, color: ColorName.primaryColor),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Center(
                                child: AppText.medium(
                                  widget.data == null
                                      ? 'Add Supplier'
                                      : 'Edit Supplier',
                                  color: ColorName.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Divider(
                                  thickness: 1, color: ColorName.lightGrey),
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
                                prefixIcon: Icon(Icons.person,
                                    color: ColorName.primaryColor),
                                validator:
                                    Functions().noSpecialCharactersValidator,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Email',
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
                                prefixIcon: Icon(Icons.email,
                                    color: ColorName.primaryColor),
                                validator: (value) => Functions()
                                    .noSpecialCharactersValidator(value,
                                        allowedCharacters: '@.'),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Phone',
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
                                prefixIcon: Icon(Icons.phone,
                                    color: ColorName.primaryColor),
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
                                'Description (Optional)',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorName.textfieldColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: ColorName.lightGrey),
                                ),
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: descrController,
                                  keyboardType: TextInputType.multiline,
                                  validator:
                                      Functions().noSpecialCharactersValidator,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  onChanged: (value) {
                                    formValidationCubit.validateField(
                                      descrKey,
                                      value.isNotEmpty,
                                    );
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.description,
                                        color: ColorName.primaryColor),
                                    hintText:
                                        "Write a summary and any detail about your Supplier",
                                    hintStyle: TextStyle(
                                      color: ColorName.mainGrey,
                                      fontSize: 14.sp,
                                      fontFamily: FontFamily.lato,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.w, 10.h, 10.w, 0),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: ColorName.blackColor,
                                    fontSize: 16.sp,
                                  ),
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
            return Container(
              margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
              width: 200.w,
              height: 50,
              child: CustomButton(
                onTap: isFormValid
                    ? () async {
                        await addSupplier(false);
                      }
                    : isFormValid && widget.data != null
                        ? () async {
                            await addSupplier(true);
                          }
                        : () {},
                text: 'Submit',
                color: isFormValid || isFormValid && widget.data != null
                    ? ColorName.primaryColor
                    : ColorName.mainGrey,
                radius: 20,
                fontWeight: FontWeight.normal,
                textColor: isFormValid || isFormValid && widget.data != null
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
