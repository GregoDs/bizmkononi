import 'package:biz_mkononi/features/categories/cubit/category_cubit.dart';
import 'package:biz_mkononi/utils/functions/functions.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';
import '../models/category_model.dart';
import '../repo/categories_repo.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key, this.data});
  final CategoryModelRow? data;

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final CategoryCubit categoryCubit = CategoryCubit(CategoriesRepo());
  final ImagePickerCubit imagePickerCubit = ImagePickerCubit();

  final nameController = TextEditingController();
  final descrController = TextEditingController();

  final nameKey = 'categoryName';
  final descrKey = 'categoryDesr';

  int getYearOfBirthFromString(String ageString) {
    int age = int.tryParse(ageString) ?? 0;
    int currentYear = DateTime.now().year;
    int yearOfBirth = currentYear - age;

    return yearOfBirth;
  }

  String formatString(String input) {
    String trimmedInput = input.trim();
    String formattedString =
        trimmedInput.substring(0, 1).toUpperCase() + trimmedInput.substring(1);

    return formattedString;
  }

  addCategory(bool isEdit) async {
    Map<String, dynamic> data = {
      'name': formatString(nameController.text),
      'description': descrController.text.isEmpty ? '' : descrController.text,
    };
    isEdit
        ? categoryCubit.editCategory(
            widget.data!.id!,
            data,
          )
        : categoryCubit.addCategory(
            data,
          );
  }

  setDatafields() async {
    formValidationCubit.resetState();
    if (widget.data != null) {
      nameController.text = widget.data!.name!;
      descrController.text = widget.data!.description ?? '';
    }
    formValidationCubit.validateField(nameKey, widget.data != null);
    formValidationCubit.validateField(descrKey, true);
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
    descrController.clear();
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
            widget.data == null ? 'Add Category' : 'Edit Category',
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<CategoryCubit, CategoryState>(
            bloc: categoryCubit,
            listener: (context, state) {
              if (state is CategoryAdded) {
                showSuccess(context, 'Good job, category added successfully');
                Navigator.pop(context, true);
              } else if (state is CategoryError) {
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
              if (state is CategoryLoading) {
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
                        bottom: 70.h,
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
                                  child: Icon(Icons.category,
                                      size: 48, color: ColorName.primaryColor),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Center(
                                child: AppText.medium(
                                  widget.data == null
                                      ? 'Add Category'
                                      : 'Edit Category',
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
                              SizedBox(height: 5.h),
                              CustomTextField(
                                controller: nameController,
                                formValidationCubit: formValidationCubit,
                                fieldId: nameKey,
                                fillColor: ColorName.textfieldColor,
                                prefixIcon: Icon(
                                  Icons.title,
                                  color: ColorName.primaryColor,
                                ),
                                validator:
                                    Functions().noSpecialCharactersValidator,
                              ),
                              SizedBox(height: 20.h),
                              AppText.medium(
                                'Description (Optional)',
                                color: Colors.black,
                              ),
                              SizedBox(height: 5.h),
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
                                  validator: (value) {
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  onChanged: (value) {
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.description,
                                      color: ColorName.primaryColor,
                                    ),
                                    hintText:
                                        "Write a summary and any detail about your Category",
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
                              SizedBox(height: 50.h),
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
              width: 300.w,
              height: 50,
              child: CustomButton(
                onTap: isFormValid && widget.data == null
                    ? () async {
                        await addCategory(false);
                      }
                    : isFormValid && widget.data != null
                        ? () async {
                            await addCategory(true);
                          }
                        : () {},
                text: 'Submit',
                color: isFormValid && widget.data == null ||
                        isFormValid && widget.data != null
                    ? ColorName.primaryColor
                    : ColorName.mainGrey,
                radius: 20,
                fontWeight: FontWeight.normal,
                textColor: isFormValid && widget.data == null ||
                        isFormValid && widget.data != null
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
