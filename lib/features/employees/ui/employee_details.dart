import 'package:biz_mkononi/features/employees/cubit/employees_cubit.dart';
import 'package:biz_mkononi/features/employees/repo/employees_repo.dart';

import '../../../exports.dart';
import 'add_employee.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({
    super.key,
    required this.employeeId,
  });

  final String employeeId;

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  final EmployeesCubit employeesCubit = EmployeesCubit(EmployeesRepo());

  @override
  void initState() {
    employeesCubit.getSingleEmployee(widget.employeeId);
    super.initState();
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
          'Employee Details',
        ),
      ),
      body: BlocConsumer<EmployeesCubit, EmployeesState>(
        bloc: employeesCubit,
        listener: (context, state) {
          if (state is EmployeesDeleted) {
            showSuccess(context, 'Good job, item deleted Successfully');
            Navigator.pop(context, true);
          }
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
          } else if (state is EmployeesError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is EmployeesSingleLoaded) {
            var data = state.data;
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    DetailsSection(
                      image: data.imageUrl,
                      tiles: [
                        DetailTile(
                          title: 'Name',
                          trailing: data.name!,
                        ),
                        DetailTile(
                          title: 'Position',
                          trailing: data.position!,
                        ),
                        DetailTile(
                          title: 'Email',
                          trailing: data.email!,
                        ),
                        DetailTile(
                          title: 'Phone',
                          trailing: data.phone!,
                        ),
                        DetailTile(
                          title: 'Date Added',
                          trailing: convertToHumanReadableDate(
                              data.createdAt.toString()),
                        ),
                        DetailTile(
                          title: '',
                          trailing: '',
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<EmployeesCubit, EmployeesState>(
        bloc: employeesCubit,
        builder: (context, state) {
          if (state is EmployeesSingleLoaded) {
            return Container(
                margin: EdgeInsets.only(left: 30.w, right: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: CustomButton(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEmployee(
                                  data: state.data,
                                ),
                              ),
                            );
                            if (result != null && result == true) {
                              employeesCubit
                                  .getSingleEmployee(widget.employeeId);
                            }
                          },
                          text: "Edit"),
                    ),
                    SizedBox(
                      width: 150,
                      child: CustomButton(
                        onTap: () => _showMyDialog(context, widget.employeeId),
                        text: "Delete",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ));
          }

          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Future<void> _showMyDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to remove the Item ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
                  overlayColor:
                      WidgetStateProperty.all<Color>(Colors.redAccent),
                ),
                child: const Text('Remove'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await employeesCubit.deleteEmployee(id);
                }),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
