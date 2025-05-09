part of 'employees_cubit.dart';

@immutable
sealed class EmployeesState {}

final class EmployeesInitial extends EmployeesState {}

final class EmployeesLoading extends EmployeesState {}

final class EmployeesLoaded extends EmployeesState {
  final List<EmployeesModelRow> data;

  EmployeesLoaded({required this.data});
}

final class EmployeesSingleLoaded extends EmployeesState {
  final EmployeesModelRow data;

  EmployeesSingleLoaded({required this.data});
}

final class EmployeesAdded extends EmployeesState {}

final class EmployeesEdit extends EmployeesState {}

final class EmployeesDeleted extends EmployeesState {}

final class EmployeesError extends EmployeesState {
  final String message;

  EmployeesError({required this.message});
}
