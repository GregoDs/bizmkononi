part of 'businesses_cubit.dart';

@immutable
sealed class BusinessesState {}

final class BusinessesInitial extends BusinessesState {}

final class BusinessesLoading extends BusinessesState {}

final class BusinessesAdded extends BusinessesState {}

final class BusinessesDeleted extends BusinessesState {}

final class BusinessesLoaded extends BusinessesState {
  final List<BusinessModelRows> data;

  BusinessesLoaded({required this.data});
}

final class BusinessDetailLoaded extends BusinessesState {
  final BusinessModelRows data;

  BusinessDetailLoaded({required this.data});
}

final class BusinessesError extends BusinessesState {
  final String message;

  BusinessesError({required this.message});
}
