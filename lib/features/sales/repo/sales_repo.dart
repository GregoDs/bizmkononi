import 'dart:convert';
import '../../../exports.dart';
import '../../../utils/globals/global.dart' as globals;

import '../models/sales_model.dart';
import '../models/single_sales_model.dart';

class SalesRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<SalesModel?> getAllSales() async {
    SalesModel? salesModel;

    debugPrint('[SalesRepo] GET /businesses/${globals.selectedBusiness}/sales');
    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/sales', false);
    debugPrint('[SalesRepo] Response: ${res.statusCode} ${res.data}');
    if (res.statusCode == 200) {
      salesModel = SalesModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return salesModel;
  }

  Future<SingleSalesModel?> getSaleDetail(String id) async {
    SingleSalesModel? salesModelRow;

    debugPrint('[SalesRepo] GET /businesses/${globals.selectedBusiness}/sales/$id');
    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/sales/$id', false);
    debugPrint('[SalesRepo] Response: ${res.statusCode} ${res.data}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      salesModelRow =
          SingleSalesModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return salesModelRow;
  }

  Future<ResponseModel> addSale(var data) async {
    debugPrint('[SalesRepo] POST /businesses/${globals.selectedBusiness}/sales');
    debugPrint('[SalesRepo] Request Body: $data');
    var res = await _apiService.post(
      '/businesses/${globals.selectedBusiness}/sales',
      data,
      false,
    );
    debugPrint('[SalesRepo] Response: ${res.statusCode} ${res.data}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Added Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res);
    }
  }

  Future<ResponseModel> editSale(
    String id,
    var data,
  ) async {
    debugPrint('[SalesRepo] PUT /businesses/${globals.selectedBusiness}/sales/$id');
    debugPrint('[SalesRepo] Request Body: $data');
    var res = await _apiService.put(
      '/businesses/${globals.selectedBusiness}/sales/$id',
      data,
    );
    debugPrint('[SalesRepo] Response: ${res.statusCode} ${res.data}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
        isSuccess: true,
        response: 'Supply Updated Successfully',
      );
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteSale(var id) async {
    debugPrint('[SalesRepo] DELETE /businesses/${globals.selectedBusiness}/sales/$id');
    var res = await _apiService.delete(
      '/businesses/${globals.selectedBusiness}/sales/$id',
    );
    debugPrint('[SalesRepo] Response: ${res.statusCode} ${res.data}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
        isSuccess: true,
        response: 'Supply Deleted Successfully',
      );
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }
}
