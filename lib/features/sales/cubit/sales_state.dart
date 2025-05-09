part of 'sales_cubit.dart';

@immutable
sealed class SalesState {}

final class SalesInitial extends SalesState {}

final class SalesLoading extends SalesState {}

final class SalesLoaded extends SalesState {
  final List<SalesModelRow> data;

  SalesLoaded({required this.data});
}

final class SalesSingleLoaded extends SalesState {
  final SingleSalesModel data;

  SalesSingleLoaded({required this.data});
}

final class SalesAdded extends SalesState {}

final class SalesDeleted extends SalesState {}

final class SalesError extends SalesState {
  final String message;

  SalesError({required this.message});
}