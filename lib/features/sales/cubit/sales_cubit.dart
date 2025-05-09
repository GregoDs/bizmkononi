import 'dart:developer';

import '../../../exports.dart';
import '../models/sales_model.dart';
import '../models/single_sales_model.dart';
import '../repo/sales_repo.dart';

part 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesRepo salesRepo;
  SalesCubit(this.salesRepo) : super(SalesInitial());

  List<SalesModelRow> sales = [];

  Future<void> getSales({String? search}) async {
    try {
      emit(SalesLoading());
      if (sales.isNotEmpty && search != null) {
        final String query = search.toLowerCase();
        List<SalesModelRow> filteredSales = sales
            .where((sale) =>
                sale.customer!.name.toString().toLowerCase().contains(query))
            .toList();
        emit(SalesLoaded(data: filteredSales.reversed.toList()));
      } else {
        final salesModel = await salesRepo.getAllSales();
        if (salesModel!.rows!.isEmpty) {
          emit(SalesLoaded(data: const []));
        } else {
          sales.addAll(salesModel.rows!);
          emit(SalesLoaded(data: salesModel.rows!.reversed.toList()));
        }
      }
    } catch (e) {
      emit(SalesError(message: e.toString()));
    }
  }

  Future<void> getSingleSale(String id) async {
    try {
      emit(SalesLoading());
      final salesModel = await salesRepo.getSaleDetail(id);
      if (salesModel == null) {
        emit(SalesError(message: 'No Item retrieved'));
      } else {
        emit(SalesSingleLoaded(data: salesModel));
      }
    } catch (e) {
      emit(SalesError(message: e.toString()));
    }
  }

  Future<void> addSale(var data) async {
    try {
      emit(SalesLoading());
      ResponseModel res = await salesRepo.addSale(data);
      if (res.isSuccess) {
        emit(SalesAdded());
      } else {
        emit(SalesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      log('Response: $e');
      emit(SalesError(message: 'Oops an error occurred Please try again... $e'));
    }
  }

  Future<void> editSale(
    String saleId,
    var data,
  ) async {
    try {
      emit(SalesLoading());
      ResponseModel res = await salesRepo.editSale(saleId, data);
      if (res.isSuccess) {
        emit(SalesAdded());
      } else {
        emit(SalesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SalesError(message: 'Oops an error occurred Please try again...'));
    }
  }

  Future<void> deleteSale(String saleId) async {
    try {
      emit(SalesLoading());
      ResponseModel res = await salesRepo.deleteSale(saleId);
      if (res.isSuccess) {
        emit(SalesDeleted());
      } else {
        emit(SalesError(message: 'No Item retrieved'));
      }
    } catch (e) {
      emit(SalesError(message: e.toString()));
    }
  }
}
