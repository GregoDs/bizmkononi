part of 'expenses_cubit.dart';

@immutable
sealed class ExpensesState {}

final class ExpensesInitial extends ExpensesState {}

final class ExpensesLoading extends ExpensesState {}

final class ExpensesLoaded extends ExpensesState {
  final List<ExpensesModelRow> data;

  ExpensesLoaded({required this.data});
}

final class ExpensesSingleLoaded extends ExpensesState {
  final ExpensesModelRow data;

  ExpensesSingleLoaded({required this.data});
}

final class ExpensesAdded extends ExpensesState {}

final class ExpensesDeleted extends ExpensesState {}

final class ExpensesError extends ExpensesState {
  final String message;

  ExpensesError({required this.message});
}