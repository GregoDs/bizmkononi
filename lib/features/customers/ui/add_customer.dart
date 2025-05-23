import 'package:biz_mkononi/utils/functions/functions.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';
import '../models/customers.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key, this.data});
  final CustomersModelRow? data;

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final CustomersCubit customersCubit = CustomersCubit(CustomersRepo());
  final GenderCubit genderCubit = GenderCubit();
  final ImagePickerCubit imagePickerCubit = ImagePickerCubit();
  final DateCubit dateCubit = DateCubit();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descrController = TextEditingController();
  final dateController = TextEditingController();

  final nameKey = 'customerName';
  final emailKey = 'customerEmail';
  final phoneKey = 'customerPhone';
  final descrKey = 'customerDescr';
  final dateKey = 'customerDate';

  int getYearOfBirthFromString(String ageString) {
    int age = int.tryParse(ageString) ?? 0;
    int currentYear = DateTime.now().year;
    int yearOfBirth = currentYear - age;

    return yearOfBirth;
  }

  DateTime getDateOfBirthFromAge(int age) {
    DateTime now = DateTime.now();
    int yearOfBirth = now.year - age;
    DateTime dateOfBirth = DateTime(yearOfBirth, 1, 1);

    return dateOfBirth;
  }

  String formatString(String input) {
    String trimmedInput = input.trim();
    String formattedString =
        trimmedInput.substring(0, 1).toUpperCase() + trimmedInput.substring(1);

    return formattedString;
  }

  addCustomer(bool isEdit) async {
    final selectedGender = genderCubit.state.name;
    Map<String, dynamic> data = {
      'name': formatString(nameController.text),
      'email': emailController.text,
      'phone': phoneController.text,
      'description': descrController.text,
      'gender': selectedGender.toUpperCase(),
      'yearOfBirth': dateController.text,
    };
    dateCubit.resetDate();
    isEdit
        ? customersCubit.editCustomer(
            widget.data!.id!,
            data,
          )
        : customersCubit.addCustomer(
            data,
          );
  }

  String calculateAge(int yearOfBirth) {
    final now = DateTime.now();
    final currentYear = now.year;
    final age = currentYear - yearOfBirth;
    return age.toString();
  }

  setDatafields() async {
    dateCubit.resetDate();
    formValidationCubit.resetState();
    if (widget.data != null) {
      nameController.text = widget.data!.name!;
      dateController.text = widget.data!.yearOfBirth!.toString();
      emailController.text = widget.data!.email!;
      phoneController.text = widget.data!.phone!;
      descrController.text = widget.data!.description!;
      if (widget.data!.gender == 'MALE') {
        genderCubit.setGender(Gender.Male);
      } else if (widget.data!.gender == 'FEMALE') {
        genderCubit.setGender(Gender.Female);
      }
    }
    formValidationCubit.validateField(nameKey, widget.data != null);
    formValidationCubit.validateField(dateKey, widget.data != null);
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
  void dispose() {
    super.dispose();
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    descrController.clear();
    dateController.clear();
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
            widget.data == null ? 'Add Customer' : 'Edit Customer',
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<CustomersCubit, CustomersState>(
            bloc: customersCubit,
            listener: (context, state) {
              if (state is CustomerAdded) {
                showSuccess(context, 'Good job, Customer added successfully');

                Navigator.pop(context, true);
              } else if (state is CustomersError) {
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
              if (state is CustomersLoading) {
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
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
                                  child: Icon(
                                    Icons.person,
                                    size: 48,
                                    color: ColorName.primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Center(
                                child: AppText.medium(
                                  widget.data == null
                                      ? 'Add Customer'
                                      : 'Edit Customer',
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
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: ColorName.primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Estimated Age (Optional)',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              BlocBuilder<DateCubit, DateTime?>(
                                bloc: dateCubit,
                                builder: (context, state) {
                                  return SizedBox(
                                    width: ScreenUtil().screenWidth,
                                    child: CustomTextField(
                                      hintText: 'Date',
                                      controller: dateController,
                                      fillColor: ColorName.textfieldColor,
                                      formValidationCubit: formValidationCubit,
                                      fieldId: dateKey,
                                      readOnly: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a date';
                                        }

                                        return null;
                                      },
                                      prefixIcon: Icon(
                                        Icons.calendar_today,
                                        color: ColorName.primaryColor,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.calendar_month),
                                        onPressed: () async {
                                          DateTime today = DateTime.now();
                                          DateTime initialDate =
                                              DateTime(today.year - 18);
                                          DateTime firstDate =
                                              DateTime(today.year - 100);
                                          DateTime lastDate =
                                              today; // This ensures that the user cannot pick a date in the future

                                          final DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate:
                                                initialDate, // This should be on or before 'lastDate'
                                            firstDate: firstDate,
                                            lastDate:
                                                lastDate, // This should be the current date to enforce the age limit
                                          );

                                          if (pickedDate != null) {
                                            dateController.text =
                                                calculateAge(pickedDate.year)
                                                    .toString();
                                            dateCubit.selectDate(pickedDate);
                                            formValidationCubit.validateField(
                                              dateKey,
                                              true,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Gender',
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
                                    child: BlocBuilder<GenderCubit, Gender>(
                                      bloc: genderCubit,
                                      builder: (context, state) =>
                                          DropdownButtonFormField<String>(
                                        decoration:
                                            const InputDecoration.collapsed(
                                                hintText: ''),
                                        value: state == Gender.PreferNotToSay
                                            ? 'Prefer not to say'
                                            : state == Gender.Male
                                                ? 'MALE'
                                                : state == Gender.Female
                                                    ? 'FEMALE'
                                                    : 'Please Select gender',
                                        hint: AppText.small(
                                          'Gender',
                                          color: ColorName.mainGrey,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        items: <String>[
                                          'Please Select gender',
                                          'Prefer not to say',
                                          'MALE',
                                          'FEMALE',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: value ==
                                                        'Please Select gender'
                                                    ? ColorName.mainGrey
                                                    : Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          if (newValue == 'Prefer not to say') {
                                            genderCubit.setGender(
                                                Gender.PreferNotToSay);
                                          } else if (newValue == 'MALE') {
                                            genderCubit.setGender(Gender.Male);
                                          } else if (newValue == 'FEMALE') {
                                            genderCubit
                                                .setGender(Gender.Female);
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
                                validator: (value) => Functions()
                                    .noSpecialCharactersValidator(value,
                                        allowedCharacters: '@.'),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: ColorName.primaryColor,
                                ),
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
                                validator: (value) =>
                                    Functions().combineValidators(value, [
                                  Functions().noSpecialCharactersValidator,
                                  Functions().phoneNumberValidator,
                                ]),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: ColorName.primaryColor,
                                ),
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
                                  prefixIcon: Icon(
                                    Icons.description,
                                    color: ColorName.primaryColor,
                                  ),
                                  hintText:
                                      "Write a summary and any detail about your Customer",
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
                                        color: ColorName.lightGrey),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: ColorName.lightGrey),
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
            String selectedGender = genderCubit.state.name;
            return Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
              width: 300.w,
              height: 50,
              child: CustomButton(
                onTap: isFormValid &&
                        selectedGender.isNotEmpty &&
                        selectedGender != 'Please Select gender' &&
                        widget.data == null
                    ? () async {
                        await addCustomer(false);
                      }
                    : isFormValid &&
                            selectedGender.isNotEmpty &&
                            selectedGender != 'Please Select gender' &&
                            widget.data != null
                        ? () async {
                            await addCustomer(true);
                          }
                        : () {},
                text: 'Submit',
                color: isFormValid &&
                            selectedGender.isNotEmpty &&
                            selectedGender != 'Please Select gender' &&
                            widget.data == null ||
                        isFormValid &&
                            selectedGender.isNotEmpty &&
                            selectedGender != 'Please Select gender' &&
                            widget.data != null
                    ? ColorName.primaryColor
                    : ColorName.mainGrey,
                radius: 20,
                fontWeight: FontWeight.normal,
                textColor: isFormValid &&
                            selectedGender.isNotEmpty &&
                            selectedGender != 'Please Select gender' &&
                            widget.data == null ||
                        isFormValid &&
                            selectedGender.isNotEmpty &&
                            selectedGender != 'Please Select gender' &&
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
                    icon: const Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      getImageDialog(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera_alt)),
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
