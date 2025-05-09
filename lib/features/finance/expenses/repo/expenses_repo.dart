import 'dart:convert';

import '../../../../exports.dart';
import '../../../../utils/globals/global.dart' as globals;

import '../models/expenses_model.dart';

class ExpensesRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<ExpensesModel?> getAllExpenses() async {
    ExpensesModel? expensesModel;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/expenses', false);
    if (res.statusCode == 200) {
      expensesModel = ExpensesModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return expensesModel;
  }

  Future<ExpensesModelRow?> getExpenseDetail(String id) async {
    ExpensesModelRow? expensesModelRow;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/expenses/$id', false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      expensesModelRow =
          ExpensesModelRow.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return expensesModelRow;
  }

  Future<ResponseModel> addExpense(var data) async {
    var res = await _apiService.post(
        '/businesses/${globals.selectedBusiness}/expenses', data, false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Added Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editExpense(String customerId, var data) async {
    var res = await _apiService.put(
        '/businesses/${globals.selectedBusiness}/expenses/$customerId', data);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteExpense(var id) async {
    var res = await _apiService
        .delete('/businesses/${globals.selectedBusiness}/expenses/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Deleted Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }
}
