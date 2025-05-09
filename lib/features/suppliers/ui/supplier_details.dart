import 'package:biz_mkononi/features/suppliers/cubit/suppliers_cubit.dart';
import 'package:biz_mkononi/features/suppliers/repo/suppliers_repo.dart';
import 'package:biz_mkononi/features/suppliers/ui/add_supplier.dart';

import '../../../exports.dart';

class SupplierDetails extends StatefulWidget {
  const SupplierDetails({
    super.key,
    required this.supplierId,
  });

  final String supplierId;

  @override
  State<SupplierDetails> createState() => _SupplierDetailsState();
}

class _SupplierDetailsState extends State<SupplierDetails> {
  final SuppliersCubit suppliersCubit = SuppliersCubit(SuppliersRepo());

  @override
  void initState() {
    suppliersCubit.getSingleSupplier(widget.supplierId);
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
          'Supplier Details',
        ),
      ),
      body: BlocConsumer<SuppliersCubit, SuppliersState>(
        bloc: suppliersCubit,
        listener: (context, state) {
          if (state is SuppliersDeleted) {
            showSuccess(context, 'Good job, item deleted Successfully');
            
            Navigator.pop(context, true);
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
          } else if (state is SuppliersError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is SuppliersSingleLoaded) {
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
                      image: data.imageUrl,
                      tiles: [
                        DetailTile(
                          title: 'Name',
                          trailing: data.name!,
                        ),
                        DetailTile(
                          title: 'Phone',
                          trailing: data.phone!,
                        ),
                        DetailTile(
                          title: 'email',
                          trailing: data.email!,
                        ),
                        DetailTile(
                          title: 'Payment for Date',
                          trailing: convertToHumanReadableDate(
                            data.createdAt.toString(),
                          ),
                        ),
                        DetailTile(
                          title: 'Description',
                          trailing: data.description!,
                        ),
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
      floatingActionButton: BlocBuilder<SuppliersCubit, SuppliersState>(
        bloc: suppliersCubit,
        builder: (context, state) {
          if (state is SuppliersSingleLoaded) {
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
                            builder: (context) => AddSupplier(
                              data: state.data,
                            ),
                          ),
                        );
                        if (result != null && result == true) {
                          suppliersCubit.getSingleSupplier(widget.supplierId);
                        }
                      },
                      text: "Edit",
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: CustomButton(
                      onTap: () => _showMyDialog(context, widget.supplierId),
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
                Text('Would you like to remove the Category ?'),
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
                  await suppliersCubit.deleteSupplier(id);
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
