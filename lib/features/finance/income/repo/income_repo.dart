import 'dart:convert';


import '../../../../exports.dart';
import '../../../../utils/globals/global.dart' as globals;

import '../models/income_model.dart';

class IncomeRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<IncomeModel?> getAllIncome() async {
    IncomeModel? incomeModel;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/incomes', false);
    if (res.statusCode == 200) {
      incomeModel = IncomeModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return incomeModel;
  }

  Future<IncomeModelRow?> getIncomeDetail(String id) async {
    IncomeModelRow? incomeModelRow;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/incomes/$id', false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      incomeModelRow =
          IncomeModelRow.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return incomeModelRow;
  }

  Future<ResponseModel> addIncome(var data) async {
    var res = await _apiService.post(
        '/businesses/${globals.selectedBusiness}/incomes', data, false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Added Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editIncome(
      String customerId, var data) async {
    var res = await _apiService.put(
        '/businesses/${globals.selectedBusiness}/incomes/$customerId', data);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteIncome(var id) async {
    var res = await _apiService
        .delete('/businesses/${globals.selectedBusiness}/incomes/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Deleted Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }
}
