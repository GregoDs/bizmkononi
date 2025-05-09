import 'package:biz_mkononi/features/products/repo/products_repo.dart';
import '../../../exports.dart';
import '../../categories/models/category_model.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsRepo productsRepo;
  ProductsCubit(this.productsRepo) : super(ProductsInitial());

  List<ProductsModelRow> products = [];
   ProductsModelRow? selectedProduct;
  

  Future<void> getProducts({String? search}) async {
    try {
      emit(ProductsLoading());
      if (products.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<ProductsModelRow> filteredProducts = products
            .where((product) =>
                product.name.toString().toLowerCase().contains(query))
            .toList();
        emit(ProductsLoaded(data: filteredProducts.reversed.toList()));
      } else {
        final productsModel = await productsRepo.getAllProducts();
        if (productsModel!.rows!.isEmpty) {
          emit(ProductsLoaded(data: const []));
        } else {
          products.addAll(productsModel.rows!);
          emit(ProductsLoaded(data: productsModel.rows!.reversed.toList()));
        }
      }
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  void setSelectedProduct(ProductsModelRow product) {
    selectedProduct = product;
    emit(ProductSelected(product: product));
  }

  Future<void> getSingleProduct(String id) async {
    try {
      emit(ProductsLoading());
      final productsModel = await productsRepo.getProductDetail(id);
      if (productsModel == null) {
        emit(ProductsError(message: 'No Item retrieved'));
      } else {
        emit(ProductsSingleLoaded(data: productsModel));
      }
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> addProduct(var data,) async {
    try {
      emit(ProductsLoading());
      ResponseModel res = await productsRepo.addProduct(data,);
      if (res.isSuccess) {
        emit(ProductsAdded());
      } else {
        emit(ProductsError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(ProductsError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> editProduct(
      String productId, var data,) async {
    try {
      emit(ProductsLoading());
      ResponseModel res =
          await productsRepo.editProduct(productId, data,);
      if (res.isSuccess) {
        emit(ProductsAdded());
      } else {
        emit(ProductsError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(ProductsError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      emit(ProductsLoading());
      ResponseModel res = await productsRepo.deleteProduct(productId);
      if (res.isSuccess) {
        emit(ProductsDeleted());
      } else {
        emit(ProductsError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }
}

class SelectedCategoryCubit extends Cubit<CategoryModelRow?> {
  SelectedCategoryCubit() : super(null);

  void setSelectedCategory(CategoryModelRow? category) {
    emit(category);
  }
}



