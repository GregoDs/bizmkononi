import 'package:biz_mkononi/features/products/ui/add_product.dart';

import '../../../exports.dart';
import '../cubit/products_cubit.dart';
import '../repo/products_repo.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ProductsCubit productsCubit = ProductsCubit(ProductsRepo());

  @override
  void initState() {
    productsCubit.getSingleProduct(widget.productId);
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
          'Product Detail',
        ),
      ),
      body: BlocConsumer<ProductsCubit, ProductsState>(
        bloc: productsCubit,
        listener: (context, state) {
          if (state is ProductsDeleted) {
            showSuccess(context, 'Good job, item deleted Successfully');
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is ProductsLoading) {
            return SpinKitWave(
              itemBuilder: (BuildContext context, int index) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    color: ColorName.primaryColor,
                  ),
                );
              },
            );
          } else if (state is ProductsError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is ProductsSingleLoaded) {
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
                      image: data.imageUrl,
                      tiles: [
                        DetailTile(
                          title: 'Name',
                          trailing: data.name!,
                        ),
                        DetailTile(
                          title: 'Product Type',
                          trailing: data.productType!,
                        ),
                        DetailTile(
                          title: 'Size',
                          trailing:
                              '${data.size.toString()} ${data.unit.toString()}',
                        ),
                        DetailTile(
                          title: 'Buying Price',
                          trailing: data.buyingPrice.toString(),
                        ),
                        DetailTile(
                          title: 'Selling Price',
                          trailing: data.sellingPrice.toString(),
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
      floatingActionButton: BlocBuilder<ProductsCubit, ProductsState>(
        bloc: productsCubit,
        builder: (context, state) {
          if (state is ProductsSingleLoaded) {
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
                              builder: (context) => AddProduct(
                                data: state.data,
                              ),
                            ),
                          );
                          if (result != null && result == true) {
                            productsCubit.getSingleProduct(widget.productId);
                          }
                        },
                        text: "Edit"),
                  ),
                  SizedBox(
                    width: 150,
                    child: CustomButton(
                      onTap: () => _showMyDialog(context, widget.productId),
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
                  await productsCubit.deleteProduct(id);
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
