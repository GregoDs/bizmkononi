import 'dart:convert';

import '../../../exports.dart';
import '../../../utils/globals/global.dart' as globals;
import 'package:dio/dio.dart' as dio;

import '../models/suppliers_model.dart';

class SuppliersRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<SuppliersModel?> getAllSuppliers() async {
    SuppliersModel? suppliersModel;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/suppliers', false);
    if (res.statusCode == 200) {
      suppliersModel =
          SuppliersModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return suppliersModel;
  }

  Future<SuppliersModelRow?> getSupplierDetail(String id) async {
    SuppliersModelRow? suppliersModelRow;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/suppliers/$id', false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      suppliersModelRow =
          SuppliersModelRow.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return suppliersModelRow;
  }

  Future<ResponseModel> addSupplier(
      var data,) async {
    var formdata = dio.FormData.fromMap(data);

    var res = await _apiService.post(
        '/businesses/${globals.selectedBusiness}/suppliers', formdata, false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supplier Added Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editSupplier(
    String customerId,
    var data,
  ) async {

    var formdata = dio.FormData.fromMap(data);
    var res = await _apiService.put(
        '/businesses/${globals.selectedBusiness}/suppliers/$customerId',
        formdata);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supplier Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteSupplier(var id) async {
    var res = await _apiService
        .delete('/businesses/${globals.selectedBusiness}/suppliers/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supplier Deleted Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }
}
