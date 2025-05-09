part of 'customers_cubit.dart';

@immutable
sealed class CustomersState {}

final class CustomersInitial extends CustomersState {}

final class CustomersLoading extends CustomersState {}

final class CustomersLoaded extends CustomersState {
  final List<CustomersModelRow> data;

  CustomersLoaded({required this.data});
}

final class CustomersSingleLoaded extends CustomersState {
  final CustomersModelRow data;

  CustomersSingleLoaded({required this.data});
}

final class CustomerAdded extends CustomersState {}

final class CustomerDeleted extends CustomersState {}

final class CustomersError extends CustomersState {
  final String message;

  CustomersError({required this.message});
}
