part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoriesLoaded extends CategoryState {
  final List<CategoryModelRow> data;

  CategoriesLoaded({required this.data});
}

final class CategorySingleLoaded extends CategoryState {
  final CategoryModelRow data;

  CategorySingleLoaded({required this.data});
}

final class CategoryAdded extends CategoryState {}


final class CategoryDeleted extends CategoryState {}

final class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});
}