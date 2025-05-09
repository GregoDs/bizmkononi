import 'package:biz_mkononi/exports.dart';

import '../models/customers.dart';

part 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  CustomersRepo customersRepo;
  CustomersCubit(this.customersRepo) : super(CustomersInitial());
  List<CustomersModelRow> customers = [];

  Future<void> getCustomers({String? search}) async {
    try {
      emit(CustomersLoading());
      if (customers.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<CustomersModelRow> filteredCustomers = customers
            .where((customer) =>
                customer.name.toString().toLowerCase().contains(query))
            .toList();
        emit(CustomersLoaded(data: filteredCustomers.reversed.toList()));
      } else {
        final customersModel = await customersRepo.getAllCustomers();
        if (customersModel!.rows!.isEmpty) {
          emit(CustomersLoaded(data: const []));
        } else {
          customers.addAll(customersModel.rows!);
          emit(CustomersLoaded(data: customersModel.rows!.reversed.toList()));
        }
      }
    } catch (e) {
      emit(CustomersError(message: e.toString()));
    }
  }

  Future<void> getSingleCustomer(String id) async {
    try {
      emit(CustomersLoading());
      final customersModel = await customersRepo.getCustomerDetail(id);
      if (customersModel == null) {
        emit(CustomersError(message: 'No Item retrieved'));
      } else {
        emit(CustomersSingleLoaded(data: customersModel));
      }
    } catch (e) {
      emit(CustomersError(message: e.toString()));
    }
  }

  Future<void> addCustomer(var data,) async {
    try {
      emit(CustomersLoading());
      ResponseModel res = await customersRepo.addCustomer(data,);
      if (res.isSuccess) {
        emit(CustomerAdded());
      } else {
        emit(CustomersError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(CustomersError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> editCustomer(
      String customerId, var data,) async {
    try {
      emit(CustomersLoading());
      ResponseModel res =
          await customersRepo.editCustomer(customerId, data,);
      if (res.isSuccess) {
        emit(CustomerAdded());
      } else {
        emit(CustomersError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(CustomersError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      emit(CustomersLoading());
      ResponseModel res = await customersRepo.deleteCustomer(customerId);
      if (res.isSuccess) {
        emit(CustomerDeleted());
      } else {
        emit(CustomersError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(CustomersError(message: e.toString()));
    }
  }
}

class SelectedCustomerCubit extends Cubit<CustomersModelRow?> {
  SelectedCustomerCubit() : super(null);

  void setSelectedCategory(CustomersModelRow? selected) {
    emit(selected);
  }
}
