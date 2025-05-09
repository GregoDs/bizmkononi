import 'package:intl/intl.dart';

import '../../../../exports.dart';
import '../cubit/expenses_cubit.dart';
import '../models/expenses_model.dart';
import '../repo/expenses_repo.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key, this.data});
  final ExpensesModelRow? data;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final ExpensesCubit expensesCubit = ExpensesCubit(ExpensesRepo());
  final DateCubit dateCubit = DateCubit();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final descrController = TextEditingController();
  String? selectedDate;

  

  final titleKey = 'expenseTitle';
  final amountKey = 'expenseAmount';
  final dateKey = 'expenseDate';
  final descrKey = 'expenseDescr';

  addExpense(bool isEdit) async {
    Map<String, dynamic> data = {
      'title': titleController.text,
      'amount': amountController.text,
      'txDate': dateController.text,
      'description': descrController.text,
    };
    dateCubit.resetDate();
    isEdit
        ? expensesCubit.editExpense(widget.data!.id!, data)
        : expensesCubit.addExpense(data);
  }

  setDatafields() async {
    // await expensesCubit.getExpenses();
    dateCubit.resetDate();
    formValidationCubit.resetState();
    if (widget.data != null) {
      titleController.text = widget.data!.title!;
      amountController.text = widget.data!.amount.toString();
      dateController.text = trimToDateString(widget.data!.createdAt.toString());
      descrController.text = widget.data!.description!;
    }
    formValidationCubit.validateField(titleKey, widget.data != null);
    formValidationCubit.validateField(amountKey, widget.data != null);
    formValidationCubit.validateField(dateKey, widget.data != null);
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
    titleController.clear();
    amountController.clear();
    dateController.clear();
    descrController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.lightGrey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context, true),
          child: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: ColorName.blue200,
        centerTitle: true,
        title: AppText.medium(
          widget.data == null ? 'Add Expense' : 'Edit Expense',
        ),
      ),
      body: BlocConsumer<ExpensesCubit, ExpensesState>(
        bloc: expensesCubit,
        listener: (context, state) {
          if (state is ExpensesAdded) {
            showSuccess(context, 'Good job, changes made Successfully');
            Navigator.pop(context, true);
          } else if (state is ExpensesError) {
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
          if (state is ExpensesLoading) {
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
          return SafeArea(
            child: SingleChildScrollView(
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
                          'Title',
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        CustomTextField(
                          controller: titleController,
                          formValidationCubit: formValidationCubit,
                          fieldId: titleKey,
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
                          'Transaction Date',
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
                          controller: amountController,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onChanged: (value) {
                            formValidationCubit.validateField(
                                descrKey, value.isNotEmpty);
                          },
                          decoration: InputDecoration(
                            hintText:
                                "Write a summary and any detail about your Expense",
                            hintStyle: TextStyle(
                              color: ColorName.mainGrey,
                              fontSize: 14.sp,
                              fontFamily: FontFamily.lato,
                            ),
                            filled: true,
                            fillColor: ColorName.textfieldColor,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: ColorName.lightGrey),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: ColorName.lightGrey),
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
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<FormValidationCubit, Map<String, bool>>(
        bloc: formValidationCubit,
        builder: (context, state) {
          bool isFormValid = formValidationCubit.isFormValid();
          return Container(
            margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
            width: 300.w,
            height: 50,
            child: CustomButton(
              onTap: isFormValid
                  ? widget.data == null
                      ? () async {
                          await addExpense(false);
                        }
                      : () async {
                          await addExpense(true);
                        }
                  : () {},
              text: 'Submit',
              color: isFormValid ? ColorName.primaryColor : ColorName.mainGrey,
              radius: 20,
              fontWeight: FontWeight.normal,
              textColor:
                  isFormValid ? ColorName.whiteColor : ColorName.lightGrey,
            ),
          );
        },
      ),
      // floatingActionButton: BlocBuilder<FormValidationCubit, Map<String, bool>>(
      //   bloc: formValidationCubit,
      //   builder: (context, state) {
      //     bool isFormValid = formValidationCubit.isFormValid();
      //     return Container(
      //       margin: EdgeInsets.only(bottom: 20.h),
      //       width: 300.w,
      //       child: CustomButton(
      //         onTap: isFormValid
      //             ? widget.data == null
      //                 ? () async {
      //                     await addExpense(false);
      //                   }
      //                 : () async {
      //                     await addExpense(true);
      //                   }
      //             : () {},
      //         text: 'Submit',
      //         color: isFormValid ? ColorName.primaryColor : ColorName.mainGrey,
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
    );
  }

  String trimToDateString(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String dateString =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    return dateString;
  }
}
