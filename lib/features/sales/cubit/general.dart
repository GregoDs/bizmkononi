import 'package:biz_mkononi/exports.dart';

import '../models/sales_model.dart';

class SelectedSaleCubit extends Cubit<List<SaleProduct>> {
  SelectedSaleCubit() : super([]);

  void addProduct(SaleProduct product) {
    final currentState = state;
    final List<SaleProduct> updatedList = List.from(currentState)..add(product);
    emit(updatedList);
  }

  void removeProduct(SaleProduct product) {
    final currentState = state;
    final List<SaleProduct> updatedList = List.from(currentState)
      ..remove(product);
    emit(updatedList);
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var product in state) {
      totalPrice += double.tryParse(product.totalAmount) ?? 0.0;
    }
    return totalPrice;
  }
}
