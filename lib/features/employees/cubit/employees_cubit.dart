import 'package:biz_mkononi/exports.dart';
import 'package:biz_mkononi/features/employees/models/employees.dart';

import '../repo/employees_repo.dart';

part 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesRepo employeesRepo;
  EmployeesCubit(this.employeesRepo) : super(EmployeesInitial());
  List<EmployeesModelRow> employees = [];

  Future<void> getEmployees({String? search}) async {
    try {
      emit(EmployeesLoading());
      if (employees.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<EmployeesModelRow> filteredEmployees = employees
            .where((customer) =>
                customer.name.toString().toLowerCase().contains(query))
            .toList();
        emit(EmployeesLoaded(data: filteredEmployees.reversed.toList()));
      } else {
        final employeesModel = await employeesRepo.getAllEmployees();
        if (employeesModel!.rows!.isEmpty) {
          emit(EmployeesLoaded(data: const []));
        } else {
          employees.addAll(employeesModel.rows!);
          emit(EmployeesLoaded(data: employeesModel.rows!.reversed.toList()));
        }
      }
    } catch (e) {
      emit(EmployeesError(message: e.toString()));
    }
  }

  Future<void> getSingleEmployee(String id) async {
    try {
      emit(EmployeesLoading());
      final employeesModel = await employeesRepo.getEmployeeDetail(id);
      if (employeesModel == null) {
        emit(EmployeesError(message: 'No Item retrieved'));
      } else {
        emit(EmployeesSingleLoaded(data: employeesModel));
      }
    } catch (e) {
      emit(EmployeesError(message: e.toString()));
    }
  }

  Future<void> addEmployee(var data,) async {
    try {
      emit(EmployeesLoading());
      ResponseModel res = await employeesRepo.addEmployee(data,);
      if (res.isSuccess) {
        emit(EmployeesAdded());
      } else {
        emit(EmployeesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(EmployeesError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> editEmployee(String id,var data,) async {
    try {
      emit(EmployeesLoading());
      ResponseModel res = await employeesRepo.editEmployee(id, data);
      if (res.isSuccess) {
        emit(EmployeesAdded());
      } else {
        emit(EmployeesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(EmployeesError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      emit(EmployeesLoading());
      ResponseModel res = await employeesRepo.deleteEmployee(id);
      if (res.isSuccess) {
        emit(EmployeesDeleted());
      } else {
        emit(EmployeesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(EmployeesError(message: e.toString()));
    }
  }
}


class SelectedEmployeeCubit extends Cubit<EmployeesModelRow?> {
  SelectedEmployeeCubit() : super(null);

  void setSelectedCategory(EmployeesModelRow? employee) {
    emit(employee);
  }
}