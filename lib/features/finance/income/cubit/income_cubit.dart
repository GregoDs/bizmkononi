
import '../../../../exports.dart';
import '../models/income_model.dart';
import '../repo/income_repo.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeRepo incomeRepo;
  IncomeCubit(this.incomeRepo) : super(IncomeInitial());

  List<IncomeModelRow> income = [];

  Future<void> getIncome({String? search}) async {
    try {
      emit(IncomeLoading());
      if (income.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<IncomeModelRow> filteredIncome = income
            .where((inc) =>
                inc.title.toString().toLowerCase().contains(query))
            .toList();
        emit(IncomeLoaded(data: filteredIncome.reversed.toList()));
      } else {
        final incomeModel = await incomeRepo.getAllIncome();
        if (incomeModel!.rows!.isEmpty) {
          emit(IncomeLoaded(data: const []));
        } else {
          income.addAll(incomeModel.rows!);
          emit(IncomeLoaded(data: incomeModel.rows!.reversed.toList()));
        }
      }
    } catch (e) {
      emit(IncomeError(message: e.toString()));
    }
  }

  Future<void> getSingleIncome(String id) async {
    try {
      emit(IncomeLoading());
      final incomeModel = await incomeRepo.getIncomeDetail(id);
      if (incomeModel == null) {
        emit(IncomeError(message: 'No Item retrieved'));
      } else {
        emit(IncomeSingleLoaded(data: incomeModel));
      }
    } catch (e) {
      emit(IncomeError(message: e.toString()));
    }
  }

  Future<void> addIncome(var data) async {
    try {
      emit(IncomeLoading());
      ResponseModel res = await incomeRepo.addIncome(data);
      if (res.isSuccess) {
        emit(IncomeAdded());
      } else {
        emit(IncomeError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(IncomeError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> editIncome(
      String id, var data) async {
    try {
      emit(IncomeLoading());
      ResponseModel res =
          await incomeRepo.editIncome(id, data);
      if (res.isSuccess) {
        emit(IncomeAdded());
      } else {
        emit(IncomeError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(IncomeError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteIncome(String id) async {
    try {
      emit(IncomeLoading());
      ResponseModel res = await incomeRepo.deleteIncome(id);
      if (res.isSuccess) {
        emit(IncomeDeleted());
      } else {
        emit(IncomeError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(IncomeError(message: e.toString()));
    }
  }
}


