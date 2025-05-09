import 'package:biz_mkononi/features/customers/ui/add_customer.dart';

import '../../../exports.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({
    super.key,
    required this.customerId,
  });

  final String customerId;

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final CustomersCubit customersCubit = CustomersCubit(CustomersRepo());

  @override
  void initState() {
    customersCubit.getSingleCustomer(widget.customerId);
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
          'Customer Details',
        ),
      ),
      body: BlocConsumer<CustomersCubit, CustomersState>(
        bloc: customersCubit,
        listener: (context, state) {
          if (state is CustomerDeleted) {
            showSuccess(context, 'Good job, item deleted Successfully');
            Navigator.pop(context, true);
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
          } else if (state is CustomersError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is CustomersSingleLoaded) {
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
                    DetailsSection(
                      isperson: true,
                      tiles: [
                        DetailTile(
                          title: 'Name',
                          trailing: data.name!,
                        ),
                        DetailTile(
                          title: 'Gender',
                          trailing: data.gender!,
                        ),
                        DetailTile(
                          title: 'Age',
                          trailing: data.yearOfBirth.toString(),
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
                          title: 'Description',
                          trailing: data.description!,
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
      floatingActionButton: BlocBuilder<CustomersCubit, CustomersState>(
        bloc: customersCubit,
        builder: (context, state) {
          if (state is CustomersSingleLoaded) {
            return Container(
              height: 60.h,
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
                                builder: (context) => AddCustomer(
                                  data: state.data,
                                ),
                              ),
                            );
                            if (result != null && result == true) {
                              customersCubit
                                  .getSingleCustomer(widget.customerId);
                            }
                          },
                          text: "Edit"),
                    ),
                    SizedBox(
                      width: 150,
                      child: CustomButton(
                        onTap: () =>
                            _showMyDialog(context, widget.customerId),
                        text: "Delete",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                );
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
                Text('Would you like to remove the Product ?'),
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
                  await customersCubit.deleteCustomer(id);
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
