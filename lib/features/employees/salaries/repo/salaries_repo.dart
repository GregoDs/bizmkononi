import 'dart:convert';

import 'package:biz_mkononi/features/employees/salaries/models/salaries_model.dart';

import '../../../../exports.dart';
import '../../../../utils/globals/global.dart' as globals;

class SalariesRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<SalariesModel?> getAllSalaries() async {
    SalariesModel? salariesModel;

    var res = await _apiService.get(
      '/businesses/${globals.selectedBusiness}/salaries',
      false,
    );
    if (res.statusCode == 200) {
      salariesModel = SalariesModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return salariesModel;
  }

  Future<SalariesModelRow?> getSalaryDetail(String id) async {
    SalariesModelRow? salariesModelRow;

    var res = await _apiService.get(
      '/businesses/${globals.selectedBusiness}/salaries/$id',
      false,
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      salariesModelRow =
          SalariesModelRow.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return salariesModelRow;
  }

  Future<ResponseModel> addSalary(var data) async {
    var res = await _apiService.post(
      '/businesses/${globals.selectedBusiness}/salaries',
      data,
      false,
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
        isSuccess: true,
        response: 'Supply Added Successfully',
      );
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editSalary(String id, var data) async {
    var res = await _apiService.put(
      '/businesses/${globals.selectedBusiness}/salaries/$id',
      data,
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Supply Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteSalary(var id) async {
    var res = await _apiService
        .delete('/businesses/${globals.selectedBusiness}/salaries/$id');
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
