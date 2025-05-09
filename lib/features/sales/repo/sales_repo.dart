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

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/sales', false);
    if (res.statusCode == 200) {
      salesModel = SalesModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return salesModel;
  }

  Future<SingleSalesModel?> getSaleDetail(String id) async {
    SingleSalesModel? salesModelRow;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/sales/$id', false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      salesModelRow =
          SingleSalesModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return salesModelRow;
  }

  Future<ResponseModel> addSale(var data) async {
    var res = await _apiService.post(
      '/businesses/${globals.selectedBusiness}/sales',
      data,
      false,
    );
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
    var res = await _apiService.put(
      '/businesses/${globals.selectedBusiness}/sales/$id',
      data,
    );
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
    var res = await _apiService.delete(
      '/businesses/${globals.selectedBusiness}/sales/$id',
    );
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
