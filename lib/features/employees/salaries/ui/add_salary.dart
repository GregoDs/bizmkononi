
import 'package:biz_mkononi/features/employees/repo/employees_repo.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../exports.dart';
import '../../cubit/employees_cubit.dart';
import '../../models/employees.dart';
import '../cubit/salaries_cubit.dart';
import '../models/salaries_model.dart';
import '../repo/salaries_repo.dart';

class AddSalary extends StatefulWidget {
  const AddSalary({super.key, this.data});
  final SalariesModelRow? data;

  @override
  State<AddSalary> createState() => _AddSalaryState();
}

class _AddSalaryState extends State<AddSalary> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final SalariesCubit salariesCubit = SalariesCubit(SalariesRepo());
  final EmployeesCubit employeesCubit = EmployeesCubit(EmployeesRepo());
  final selectedEmployeeCubit = SelectedEmployeeCubit();
  final DateCubit dateCubit = DateCubit();

  final employeeNameController = TextEditingController();
  final employeeIdController = TextEditingController();
  final salaryAmountController = TextEditingController();
  final descrController = TextEditingController();
  final dateController = TextEditingController();

  final nameKey = 'salaryEmployee';
  final amountKey = 'salaryAmount';
  final descrKey = 'salaryDescr';
  final dateKey = 'salaryDate';

  addSalary(bool isEdit) async {
    double amount = double.parse(salaryAmountController.text);
    Map<String, dynamic> data = {
      'employeeName': isEdit
          ? employeeNameController.text
          : selectedEmployeeCubit.state!.name,
      'txDate': dateCubit.state == null ? dateController.text :  DateFormat('yyyy-MM-dd').format(dateCubit.state!),
      'amount': amount,
      'description': descrController.text,
      'employeeId':
          isEdit ? employeeIdController.text : selectedEmployeeCubit.state!.id,
    };
    
    isEdit
        ? salariesCubit.editSalary(widget.data!.id!, data)
        : salariesCubit.addSalary(data);

        dateCubit.resetDate();
  }

  setDatafields() async {
    dateCubit.resetDate();
    employeesCubit.getEmployees();
    formValidationCubit.resetState();
    // await salariesCubit.getSalaries();
    if (widget.data != null) {
      salaryAmountController.text = widget.data!.amount!;
      dateController.text =
          DateFormat('yyyy-MM-dd').format(widget.data!.txDate!);
      descrController.text = widget.data!.description!;
      employeeNameController.text = widget.data!.employee!.name!;
      employeeIdController.text = widget.data!.employeeId!;
    }
    // formValidationCubit.validateField(nameKey, widget.data != null);
    formValidationCubit.validateField(amountKey, widget.data != null);
    formValidationCubit.validateField(descrKey, widget.data != null);
    formValidationCubit.validateField(dateKey, widget.data != null);
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
      ),
      child: Scaffold(
        backgroundColor: ColorName.lightGrey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context, true),
            child: const Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: ColorName.blue200,
          centerTitle: true,
          title: AppText.medium(
            widget.data == null ? 'Add Salary' : 'Edit Salary',
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<SalariesCubit, SalariesState>(
            bloc: salariesCubit,
            listener: (context, state) {
              if (state is SalariesAdded) {
                showSuccess(context, 'Good job, changes made Successfully');
                Navigator.pop(context, true);
              } else if (state is SalariesError) {
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
              // else if (state is SalariesUpdated) {
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const Salaries(),
              //     ),
              //   );
              // }
            },
            builder: (context, state) {
              if (state is SalariesLoading) {
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
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.medium(
                            'Employee Name',
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          widget.data != null
                              ? CustomTextField(
                                  controller: employeeNameController,
                                  formValidationCubit: formValidationCubit,
                                  fieldId: '',
                                  readOnly: true,
                                  fillColor: ColorName.textfieldColor,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }

                                    return null;
                                  },
                                )
                              : Container(
                                  width: ScreenUtil().screenWidth,
                                  height: ScreenUtil().setHeight(50),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: ColorName.textfieldColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border:
                                        Border.all(color: ColorName.blackColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: BlocBuilder<EmployeesCubit,
                                                EmployeesState>(
                                              bloc: employeesCubit,
                                              builder: (context, state) {
                                                if (state is EmployeesLoaded) {
                                                  return BlocBuilder<
                                                      SelectedEmployeeCubit,
                                                      EmployeesModelRow?>(
                                                    bloc: selectedEmployeeCubit,
                                                    builder: (context,
                                                        selectedState) {
                                                      final selectedEmployee =
                                                          selectedEmployeeCubit
                                                              .state;
                                                      final selectedCategoryName =
                                                          selectedEmployee
                                                                  ?.name ??
                                                              'Select Employee';
                                                      return DropdownButtonHideUnderline(
                                                        child: DropdownButton<
                                                            EmployeesModelRow>(
                                                          value:
                                                              selectedEmployee,
                                                          items: state.data.map<
                                                              DropdownMenuItem<
                                                                  EmployeesModelRow>>(
                                                            (EmployeesModelRow
                                                                category) {
                                                              return DropdownMenuItem<
                                                                  EmployeesModelRow>(
                                                                value: category,
                                                                child: Text(
                                                                  category.name ??
                                                                      '',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: ColorName
                                                                        .blackColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              );
                                                            },
                                                          ).toList(),
                                                          onChanged:
                                                              (EmployeesModelRow?
                                                                  newValue) {
                                                            selectedEmployeeCubit
                                                                .setSelectedCategory(
                                                                    newValue);
                                                          },
                                                          icon: const Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              color: ColorName
                                                                  .blackColor),
                                                          iconSize: 24,
                                                          isExpanded: true,
                                                          underline: const SizedBox(),
                                                          hint: Text(
                                                            selectedCategoryName,
                                                            style: TextStyle(
                                                              color: ColorName
                                                                  .mainGrey,
                                                              fontSize: 14.sp,
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
                                                        (BuildContext context,
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
                            'Salary for this date',
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
                                      return 'Please enter A date';
                                    }

                                    return null;
                                  },
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_month),
                                    onPressed: () async {
                                      DateTime today = DateTime.now();
                                      DateTime initialDate =
                                          DateTime(today.year - 1);
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
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        dateCubit.selectDate(pickedDate);
                                        formValidationCubit.validateField(
                                            dateKey, true);
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
                            'Amount',
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          CustomTextField(
                            controller: salaryAmountController,
                            formValidationCubit: formValidationCubit,
                            fieldId: amountKey,
                            fillColor: ColorName.textfieldColor,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }

                              return null;
                            },
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
                            height: 100.h,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
                onTap: isFormValid && selectedEmployeeCubit.state != null
                    ? () async {
                        await addSalary(false);
                      }
                    : isFormValid && widget.data != null
                        ? () async {
                            await addSalary(true);
                          }
                        : () {},
                text: 'Submit',
                color: isFormValid && selectedEmployeeCubit.state != null ||
                        isFormValid && widget.data != null
                    ? ColorName.primaryColor
                    : ColorName.mainGrey,
                radius: 20,
                fontWeight: FontWeight.normal,
                textColor: isFormValid && selectedEmployeeCubit.state != null ||
                        isFormValid && widget.data != null
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
        //         onTap: isFormValid && selectedEmployeeCubit.state != null
        //             ? widget.data == null
        //                 ? () async {
        //                     await addSalary(false);
        //                   }
        //                 : () async {
        //                     await addSalary(true);
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
