part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<ProductsModelRow> data;

  ProductsLoaded({required this.data});
}

final class ProductsSingleLoaded extends ProductsState {
  final ProductsModelRow data;

  ProductsSingleLoaded({required this.data});
}

final class ProductsAdded extends ProductsState {}

final class ProductsDeleted extends ProductsState {}

final class ProductSelected extends ProductsState {
  final ProductsModelRow product;

  ProductSelected({required this.product});
}

final class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}
