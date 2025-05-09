import 'package:biz_mkononi/exports.dart';

import '../models/supplies_model.dart';

class SelectedSupplyCubit extends Cubit<List<SupplyProduct>> {
  SelectedSupplyCubit() : super([]);

  void addProduct(SupplyProduct product) {
    final currentState = state;
    final List<SupplyProduct> updatedList = List.from(currentState)..add(product);
    emit(updatedList);
  }

  void removeProduct(SupplyProduct product) {
    final currentState = state;
    final List<SupplyProduct> updatedList = List.from(currentState)..remove(product);
    emit(updatedList);
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var product in state) {
      totalPrice += double.tryParse(product.supplyPrice) ?? 0.0;
    }
    return totalPrice;
  }
}