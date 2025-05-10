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
          'Product Details',
          color: Colors.white,
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductsError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is ProductsSingleLoaded) {
            var data = state.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  // Product Icon
                  Image.asset(
                    'assets/images/products/productdetail.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 20.h),
                  // Product Details Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        _buildDetailRow('Name', data.name ?? 'N/A'),
                        _buildDetailRow(
                            'Category', data.category?.name ?? 'N/A'),
                        _buildDetailRow(
                          'Size',
                          data.size != null && data.unit != null
                              ? '${data.size} ${data.unit}'
                              : 'N/A',
                        ),
                        _buildDetailRow(
                          'Selling Price',
                          data.sellingPrice != null
                              ? '${data.sellingPrice}'
                              : 'N/A',
                        ),
                        _buildDetailRow(
                          'Buying Price',
                          data.buyingPrice != null
                              ? '${data.buyingPrice}'
                              : 'N/A',
                        ),
                        _buildDetailRow(
                          'Stock',
                          data.stock != null ? '${data.stock}' : 'N/A',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                 // Edit and Delete Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProduct(data: data),
                              ),
                            );
                            if (result != null && result == true) {
                              productsCubit.getSingleProduct(widget.productId);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          child: AppText.medium(
                            'Edit Product',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: () =>
                              _showMyDialog(context, widget.productId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          child: AppText.medium(
                            'Delete Product',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
          title: AppText.medium('Delete Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                AppText.small('Would you like to remove the Product?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.redAccent),
              ),
              child: AppText.medium('Remove', color: Colors.red),
              onPressed: () async {
                Navigator.of(context).pop();
                await productsCubit.deleteProduct(id);
              },
            ),
            TextButton(
              child: AppText.medium('Cancel', color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method to build a detail row
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.medium(
            '$title :',
            color: Colors.black,
          ),
          AppText.medium(
            value,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}