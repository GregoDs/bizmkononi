part of 'salaries_cubit.dart';

@immutable
sealed class SalariesState {}

final class SalariesInitial extends SalariesState {}

final class SalariesLoading extends SalariesState {}

final class SalariesLoaded extends SalariesState {
  final List<SalariesModelRow> data;
  

  SalariesLoaded({required this.data});
}

final class SalariesSingleLoaded extends SalariesState {
  final SalariesModelRow data;

  SalariesSingleLoaded({required this.data});
}

final class SalariesAdded extends SalariesState {}

final class SalariesUpdated extends SalariesState {}

final class SalariesDeleted extends SalariesState {}

final class SalariesError extends SalariesState {
  final String message;

  SalariesError({required this.message});
}