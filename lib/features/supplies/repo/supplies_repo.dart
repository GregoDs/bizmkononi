import 'dart:convert';

import 'package:biz_mkononi/features/supplies/models/supplies_model.dart';

import '../../../exports.dart';
import '../../../utils/globals/global.dart' as globals;

import '../models/single_supply_model.dart';

class SuppliesRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<SuppliesModel?> getAllSupplies() async {
    SuppliesModel? suppliesModel;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/supplies', false);
    if (res.statusCode == 200) {
      suppliesModel = SuppliesModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return suppliesModel;
  }

  Future<SingleSupplyModel?> getSupplyDetail(String id) async {
    SingleSupplyModel? singleSupplyModel;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/supplies/$id', false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      singleSupplyModel =
          SingleSupplyModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return singleSupplyModel;
  }

  Future<ResponseModel> addSupply(var data) async {
    var res = await _apiService.post(
        '/businesses/${globals.selectedBusiness}/supplies', data, false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Added Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editSupply(
      String customerId, var data) async {
    var res = await _apiService.put(
        '/businesses/${globals.selectedBusiness}/supplies/$customerId', data);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteSupply(var id) async {
    var res = await _apiService
        .delete('/businesses/${globals.selectedBusiness}/supplies/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Deleted Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }
}
