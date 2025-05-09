part of 'income_cubit.dart';

@immutable
sealed class IncomeState {}

final class IncomeInitial extends IncomeState {}

final class IncomeLoading extends IncomeState {}

final class IncomeLoaded extends IncomeState {
  final List<IncomeModelRow> data;

  IncomeLoaded({required this.data});
}

final class IncomeSingleLoaded extends IncomeState {
  final IncomeModelRow data;

  IncomeSingleLoaded({required this.data});
}

final class IncomeAdded extends IncomeState {}

final class IncomeDeleted extends IncomeState {}

final class IncomeError extends IncomeState {
  final String message;

  IncomeError({required this.message});
}