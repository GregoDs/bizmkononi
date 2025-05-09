import 'package:biz_mkononi/utils/functions/functions.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';
import '../cubit/employees_cubit.dart';
import '../models/employees.dart';
import '../repo/employees_repo.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key, this.data});
  final EmployeesModelRow? data;

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final EmployeesCubit employeesCubit = EmployeesCubit(EmployeesRepo());
  final GenderCubit genderCubit = GenderCubit();
  final ImagePickerCubit imagePickerCubit = ImagePickerCubit();

  final nameController = TextEditingController();
  final idController = TextEditingController();
  // final genderController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final positionController = TextEditingController();

  

  final nameKey = 'employeeName';
  final idKey = 'employeeId';
  final emailKey = 'employeeEmail';
  final phoneKey = 'employeePhone';
  final positionKey = 'employeePosition';

  String formatString(String input) {
    // Trim leading and trailing spaces
    String trimmedInput = input.trim();

    // Capitalize the first letter
    String formattedString =
        trimmedInput.substring(0, 1).toUpperCase() + trimmedInput.substring(1);

    return formattedString;
  }

  addEmployee(bool isEdit) async {
    Map<String, dynamic> data = {
      'name': formatString(nameController.text),
      'email': emailController.text,
      'phone': phoneController.text,
      'idNumber': idController.text,
      'position': positionController.text,
    };
    isEdit
        ? employeesCubit.editEmployee(
            widget.data!.id!,
            data,
          )
        : employeesCubit.addEmployee(
            data,
          );
  }

  setDatafields() async {
    formValidationCubit.resetState();
    if (widget.data != null) {
      nameController.text = widget.data!.name!;
      idController.text = widget.data!.idNumber.toString();
      emailController.text = widget.data!.email!;
      phoneController.text = widget.data!.phone!;
      positionController.text = widget.data!.position!;
    }
    formValidationCubit.validateField(nameKey, widget.data != null);
    formValidationCubit.validateField(idKey, widget.data != null);
    formValidationCubit.validateField(emailKey, widget.data != null);
    formValidationCubit.validateField(phoneKey, widget.data != null);
    formValidationCubit.validateField(positionKey, widget.data != null);
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
    idController.clear();
    emailController.clear();
    phoneController.clear();
    positionController.clear();
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
            widget.data == null ? 'Add Employee' : 'Edit Employee',
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<EmployeesCubit, EmployeesState>(
            bloc: employeesCubit,
            listener: (context, state) {
              if (state is EmployeesAdded) {
                showSuccess(context, 'Good job, changes made Successfully');
                Navigator.pop(context, true);
              } else if (state is EmployeesError) {
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
              // else if (state is EmployeesEdit) {

              // }
            },
            builder: (context, state) {
              if (state is EmployeesLoading) {
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
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
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
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'ID Number',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: idController,
                                formValidationCubit: formValidationCubit,
                                fieldId: idKey,
                                fillColor: ColorName.textfieldColor,
                                keyboardType: TextInputType.number,
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
                                'Position',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: positionController,
                                formValidationCubit: formValidationCubit,
                                fieldId: positionKey,
                                fillColor: ColorName.textfieldColor,
                                validator:
                                    Functions().noSpecialCharactersValidator,
                              ),
                              SizedBox(
                                height: 50.h,
                              ),
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
              color: Colors.transparent,
              margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
              width: 300.w,
              height: 50,
              child: CustomButton(
                onTap: isFormValid && widget.data == null
                    ? () async {
                        await addEmployee(false);
                      }
                    : isFormValid && widget.data != null
                        ? () async {
                            await addEmployee(true);
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
