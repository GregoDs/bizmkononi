part of 'supplies_cubit.dart';

@immutable
sealed class SuppliesState {}

final class SuppliesInitial extends SuppliesState {}

final class SuppliesLoading extends SuppliesState {}

final class SuppliesLoaded extends SuppliesState {
  final List<SuppliesModelRow> data;

  SuppliesLoaded({required this.data});
}

final class SuppliesSingleLoaded extends SuppliesState {
  final SingleSupplyModel data;

  SuppliesSingleLoaded({required this.data});
}

final class SuppliesAdded extends SuppliesState {}

final class SuppliesDeleted extends SuppliesState {}

final class SuppliesError extends SuppliesState {
  final String message;

  SuppliesError({required this.message});
}