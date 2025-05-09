part of 'suppliers_cubit.dart';

@immutable
sealed class SuppliersState {}

final class SuppliersInitial extends SuppliersState {}

final class SuppliersLoading extends SuppliersState {}

final class SuppliersLoaded extends SuppliersState {
  final List<SuppliersModelRow> data;

  SuppliersLoaded({required this.data});
}

final class SuppliersSingleLoaded extends SuppliersState {
  final SuppliersModelRow data;

  SuppliersSingleLoaded({required this.data});
}

final class SuppliersAdded extends SuppliersState {}

final class SuppliersEdited extends SuppliersState {}

final class SuppliersDeleted extends SuppliersState {}

final class SuppliersError extends SuppliersState {
  final String message;

  SuppliersError({required this.message});
}