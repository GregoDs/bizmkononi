part of 'insights_cubit.dart';

@immutable
sealed class InsightsState {}

final class InsightsInitial extends InsightsState {}

final class InsightsLoading extends InsightsState {}

final class InsightsLoaded extends InsightsState {
  final List<dynamic> data;

  InsightsLoaded({required this.data});
}

final class InsightsError extends InsightsState {
  final String message;

  InsightsError({required this.message});
}
