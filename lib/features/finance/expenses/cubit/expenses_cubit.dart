
import '../../../../exports.dart';
import '../models/expenses_model.dart';
import '../repo/expenses_repo.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesRepo expensesRepo;
  ExpensesCubit(this.expensesRepo) : super(ExpensesInitial());

  List<ExpensesModelRow> expenses = [];

  Future<void> getExpenses({String? search}) async {
    try {
      emit(ExpensesLoading());
      if (expenses.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<ExpensesModelRow> filteredExpenses = expenses
            .where((expense) =>
                expense.title.toString().toLowerCase().contains(query))
            .toList();
        emit(ExpensesLoaded(data: filteredExpenses.reversed.toList()));
      } else {
        final expensesModel = await expensesRepo.getAllExpenses();
        if (expensesModel!.rows!.isEmpty) {
          emit(ExpensesLoaded(data: const []));
        } else {
          expenses.addAll(expensesModel.rows!);
          emit(ExpensesLoaded(data: expensesModel.rows!.reversed.toList()));
        }
      }
    } catch (e) {
      emit(ExpensesError(message: e.toString()));
    }
  }

  Future<void> getSingleExpense(String id) async {
    try {
      emit(ExpensesLoading());
      final expensesModel = await expensesRepo.getExpenseDetail(id);
      if (expensesModel == null) {
        emit(ExpensesError(message: 'No Item retrieved'));
      } else {
        emit(ExpensesSingleLoaded(data: expensesModel));
      }
    } catch (e) {
      emit(ExpensesError(message: e.toString()));
    }
  }

  Future<void> addExpense(var data) async {
    try {
      emit(ExpensesLoading());
      ResponseModel res = await expensesRepo.addExpense(data);
      if (res.isSuccess) {
        emit(ExpensesAdded());
      } else {
        emit(ExpensesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(ExpensesError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> editExpense(
      String id, var data) async {
    try {
      emit(ExpensesLoading());
      ResponseModel res =
          await expensesRepo.editExpense(id, data);
      if (res.isSuccess) {
        emit(ExpensesAdded());
      } else {
        emit(ExpensesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(ExpensesError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      emit(ExpensesLoading());
      ResponseModel res = await expensesRepo.deleteExpense(id);
      if (res.isSuccess) {
        emit(ExpensesDeleted());
      } else {
        emit(ExpensesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(ExpensesError(message: 'Oops an error occurred Please try again...'));
    }
  }
}

