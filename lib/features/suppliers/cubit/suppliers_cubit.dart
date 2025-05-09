import 'package:biz_mkononi/features/suppliers/models/suppliers_model.dart';

import '../../../exports.dart';
import '../repo/suppliers_repo.dart';

part 'suppliers_state.dart';

class SuppliersCubit extends Cubit<SuppliersState> {
  SuppliersRepo suppliersRepo;
  SuppliersCubit(this.suppliersRepo) : super(SuppliersInitial());

  List<SuppliersModelRow> suppliers = [];

  Future<void> getSuppliers({String? search}) async {
    try {
      emit(SuppliersLoading());
      if (suppliers.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<SuppliersModelRow> filteredSuppliers = suppliers
            .where((supplier) =>
                supplier.name.toString().toLowerCase().contains(query))
            .toList();
        emit(SuppliersLoaded(data: filteredSuppliers.reversed.toList()));
      } else {
        final suppliersModel = await suppliersRepo.getAllSuppliers();
        if (suppliersModel!.rows!.isEmpty) {
          emit(SuppliersLoaded(data: const []));
        } else {
          suppliers.addAll(suppliersModel.rows!);
          emit(SuppliersLoaded(data: suppliersModel.rows!.reversed.toList()));
        }
      }
    } catch (e) {
      emit(SuppliersError(message: e.toString()));
    }
  }

  Future<void> getSingleSupplier(String id) async {
    try {
      emit(SuppliersLoading());
      final suppliersModel = await suppliersRepo.getSupplierDetail(id);
      if (suppliersModel == null) {
        emit(SuppliersError(message: 'No Item retrieved'));
      } else {
        emit(SuppliersSingleLoaded(data: suppliersModel));
      }
    } catch (e) {
      emit(SuppliersError(message: e.toString()));
    }
  }

  Future<void> addSupplier(var data,) async {
    try {
      emit(SuppliersLoading());
      ResponseModel res = await suppliersRepo.addSupplier(data,);
      if (res.isSuccess) {
        emit(SuppliersAdded());
      } else {
        emit(SuppliersError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SuppliersError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> editSupplier(String supplierId, var data,) async {
    try {
      emit(SuppliersLoading());
      ResponseModel res =
          await suppliersRepo.editSupplier(supplierId, data,);
      if (res.isSuccess) {
        emit(SuppliersAdded());
      } else {
        emit(SuppliersError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SuppliersError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteSupplier(String supplierId) async {
    try {
      emit(SuppliersLoading());
      ResponseModel res = await suppliersRepo.deleteSupplier(supplierId);
      if (res.isSuccess) {
        emit(SuppliersDeleted());
      } else {
        emit(SuppliersError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SuppliersError(message: e.toString()));
    }
  }
}


class SelectedSupplierCubit extends Cubit<SuppliersModelRow?> {
  SelectedSupplierCubit() : super(null);

  void setSelectedCategory(SuppliersModelRow? selected) {
    emit(selected);
  }
}