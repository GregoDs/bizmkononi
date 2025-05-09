part of 'profits_cubit.dart';

@immutable
sealed class ProfitsInsightState {}

final class ProfitsInsightInitial extends ProfitsInsightState {}

final class ProfitsInsightLoading extends ProfitsInsightState {}

final class ProfitsInsightLoaded extends ProfitsInsightState {
  final List<dynamic> data;

  ProfitsInsightLoaded({required this.data});
}

final class ProfitsInsightError extends ProfitsInsightState {
  final String message;

  ProfitsInsightError({required this.message});
}