
import '../../../exports.dart';
import '../models/single_supply_model.dart';
import '../models/supplies_model.dart';
import '../repo/supplies_repo.dart';

part 'supplies_state.dart';

class SuppliesCubit extends Cubit<SuppliesState> {
  SuppliesRepo suppliesRepo;
  SuppliesCubit(this.suppliesRepo) : super(SuppliesInitial());

  List<SuppliesModelRow> supplies = [];

  Future<void> getSupplies({String? search}) async {
    try {
      emit(SuppliesLoading());
      if (supplies.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<SuppliesModelRow> filteredSupplies = supplies
            .where((supply) =>
                supply.supplier!.name.toString().toLowerCase().contains(query))
            .toList();
        emit(SuppliesLoaded(data: filteredSupplies.reversed.toList()));
      } else {
        final suppliesModel = await suppliesRepo.getAllSupplies();
        if (suppliesModel!.rows!.isEmpty) {
          emit(SuppliesLoaded(data: const []));
        } else {
          supplies.addAll(suppliesModel.rows!);
          emit(SuppliesLoaded(data: suppliesModel.rows!.reversed.toList()));
        }
      }
    } catch (e) {
      emit(SuppliesError(message: e.toString()));
    }
  }

  Future<void> getSingleSupply(String id) async {
    try {
      emit(SuppliesLoading());
      final suppliesModel = await suppliesRepo.getSupplyDetail(id);
      if (suppliesModel == null) {
        emit(SuppliesError(message: 'No Item retrieved'));
      } else {
        emit(SuppliesSingleLoaded(data: suppliesModel));
      }
    } catch (e) {
      emit(SuppliesError(message: e.toString()));
    }
  }

  Future<void> addSupply(var data) async {
    try {
      emit(SuppliesLoading());
      ResponseModel res = await suppliesRepo.addSupply(data);
      if (res.isSuccess) {
        emit(SuppliesAdded());
      } else {
        emit(SuppliesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SuppliesError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> editSupply(
      String supplyId, var data) async {
    try {
      emit(SuppliesLoading());
      ResponseModel res =
          await suppliesRepo.editSupply(supplyId, data);
      if (res.isSuccess) {
        emit(SuppliesAdded());
      } else {
        emit(SuppliesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SuppliesError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteSupply(String supplyId) async {
    try {
      emit(SuppliesLoading());
      ResponseModel res = await suppliesRepo.deleteSupply(supplyId);
      if (res.isSuccess) {
        emit(SuppliesDeleted());
      } else {
        emit(SuppliesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SuppliesError(message: e.toString()));
    }
  }
}
