// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biz_mkononi/features/businesses/ui/add_business.dart';

import '../../../exports.dart';

class BusinessDetail extends StatefulWidget {
  const BusinessDetail({super.key, required this.bizId});

  final String bizId;

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  BusinessesCubit businessesCubit = BusinessesCubit(BusinessesRepo());

  @override
  void initState() {
    businessesCubit.getSingleBusiness(widget.bizId);
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
          'Business Detail',
        ),
      ),
      body: BlocConsumer<BusinessesCubit, BusinessesState>(
        bloc: businessesCubit,
        listener: (context, state) {
          if (state is BusinessesDeleted) {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, Routes.landingScreen);
            }
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
          } else if (state is BusinessesError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is BusinessDetailLoaded) {
            BusinessModelRows data = state.data;
            String? image = data.imageUrl;
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
                      image: image,
                      tiles: [
                        DetailTile(title: 'Name', trailing: data.name!),
                        DetailTile(
                            title: 'Email', trailing: data.businessEmail!),
                        DetailTile(
                            title: 'Phone', trailing: data.businessPhone!),
                        DetailTile(title: 'Admin', trailing: data.owner!.name!),
                        DetailTile(
                            title: 'Location',
                            trailing:
                                '${data.location!},${data.locationDetails!}'),
                        DetailTile(
                            title: 'Product Type', trailing: data.productType!),
                        DetailTile(
                            title: 'Description', trailing: data.description!)
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: CustomButton(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddBusiness(
                                    data: state.data,
                                  ),
                                ),
                              );
                              if (result != null && result == true) {
                                businessesCubit.getSingleBusiness(widget.bizId);
                              }
                            },
                            text: "Edit",
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: CustomButton(
                            onTap: () => _showMyDialog(context, widget.bizId),
                            text: "Delete",
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
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
                await businessesCubit.deleteProduct(id);
              },
            ),
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
