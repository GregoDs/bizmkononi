
import '../../../../exports.dart';
import '../models/salaries_model.dart';
import '../repo/salaries_repo.dart';

part 'salaries_state.dart';

class SalariesCubit extends Cubit<SalariesState> {
  SalariesRepo salariesRepo;
  SalariesCubit(this.salariesRepo) : super(SalariesInitial());

  List<SalariesModelRow> salaries = [];

  Future<void> getSalaries({String? search}) async {
    try {
      emit(SalariesLoading());
      if (salaries.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<SalariesModelRow> filteredSalaries = salaries
            .where((salary) =>
                salary.employee!.name.toString().toLowerCase().contains(query))
            .toList();
        emit(SalariesLoaded(data: filteredSalaries.reversed.toList()));
      } else {
        final salariesModel = await salariesRepo.getAllSalaries();
        if (salariesModel!.rows!.isEmpty) {
          emit(SalariesLoaded(data: const []));
        } else {
          salaries.addAll(salariesModel.rows!);
          emit(SalariesLoaded(data: salariesModel.rows!.reversed.toList()));
        }
      }
    } catch (e) {
      emit(SalariesError(message: e.toString()));
    }
  }

  Future<void> getSingleSalary(String id) async {
    try {
      emit(SalariesLoading());
      final salariesModel = await salariesRepo.getSalaryDetail(id);
      if (salariesModel == null) {
        emit(SalariesError(message: 'No Item retrieved'));
      } else {
        emit(SalariesSingleLoaded(data: salariesModel));
      }
    } catch (e) {
      emit(SalariesError(message: e.toString()));
    }
  }

  Future<void> addSalary(var data) async {
    try {
      emit(SalariesLoading());
      ResponseModel res = await salariesRepo.addSalary(data);
      if (res.isSuccess) {
        emit(SalariesAdded());
      } else {
        emit(SalariesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SalariesError(message: e.toString()));
    }
  }

  Future<void> editSalary(
      String id, var data,) async {
    try {
      emit(SalariesLoading());
      ResponseModel res =
          await salariesRepo.editSalary(id, data);
      if (res.isSuccess) {
        emit(SalariesAdded());
      } else {
        emit(SalariesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SalariesError(message: e.toString()));
    }
  }

  Future<void> deleteSalaries(String supplyId) async {
    try {
      emit(SalariesLoading());
      ResponseModel res = await salariesRepo.deleteSalary(supplyId);
      if (res.isSuccess) {
        emit(SalariesDeleted());
      } else {
        emit(SalariesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SalariesError(message: e.toString()));
    }
  }
}
