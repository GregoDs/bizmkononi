
import '../../../exports.dart';
import '../models/category_model.dart';
import '../repo/categories_repo.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoriesRepo categoriesRepo;
  CategoryCubit(this.categoriesRepo) : super(CategoryInitial());

  List<CategoryModelRow> categories = [];

  Future<void> getCategories({String? search}) async {
    try {
      emit(CategoryLoading());
      if (categories.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<CategoryModelRow> filteredCategories = categories
            .where((category) =>
                category.name.toString().toLowerCase().contains(query))
            .toList();
        emit(CategoriesLoaded(data: filteredCategories));
      } else {
        final categoriesModel = await categoriesRepo.getAllCategories();
        if (categoriesModel!.rows!.isEmpty) {
          emit(CategoriesLoaded(data: const []));
        } else {
          categories.addAll(categoriesModel.rows!);
          emit(CategoriesLoaded(data: categoriesModel.rows!));
        }
      }
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> getSingleCategory(String id) async {
    try {
      emit(CategoryLoading());
      final categoriesModel = await categoriesRepo.getCategoryDetail(id);
      if (categoriesModel == null) {
        emit(CategoryError(message: 'No Item retrieved'));
      } else {
        emit(CategorySingleLoaded(data: categoriesModel));
      }
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> addCategory(var data,) async {
    try {
      emit(CategoryLoading());
      ResponseModel res = await categoriesRepo.addCategory(data,);
      if (res.isSuccess) {
        emit(CategoryAdded());
      } else {
        emit(CategoryError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(CategoryError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> editCategory(
      String categoryId, var data,) async {
    try {
      emit(CategoryLoading());
      ResponseModel res =
          await categoriesRepo.editCategory(categoryId, data,);
      if (res.isSuccess) {
        emit(CategoryAdded());
      } else {
        emit(CategoryError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(CategoryError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      emit(CategoryLoading());
      ResponseModel res = await categoriesRepo.deleteCategory(categoryId);
      if (res.isSuccess) {
        emit(CategoryDeleted());
      } else {
        emit(CategoryError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
