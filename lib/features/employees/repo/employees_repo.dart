import 'dart:convert';

import 'package:biz_mkononi/features/employees/models/employees.dart';

import '../../../exports.dart';
import '../../../utils/globals/global.dart' as globals;
import 'package:dio/dio.dart' as dio;

class EmployeesRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<EmployeesModel?> getAllEmployees() async {
    EmployeesModel? employeesModel;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/employees', false);
    if (res.statusCode == 200) {
      employeesModel =
          EmployeesModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return employeesModel;
  }

  Future<EmployeesModelRow?> getEmployeeDetail(String id) async {
    EmployeesModelRow? employeesModelRow;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/employees/$id', false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      employeesModelRow =
          EmployeesModelRow.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return employeesModelRow;
  }

  Future<ResponseModel> addEmployee(
      var data,) async {
    var formdata = dio.FormData.fromMap(data);

    var res = await _apiService.post(
      '/businesses/${globals.selectedBusiness}/employees',
      formdata,
      false,
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Customer Added Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editEmployee(
    String customerId,
    var data,
  ) async {

    var formdata = dio.FormData.fromMap(data);
    var res = await _apiService.put(
      '/businesses/${globals.selectedBusiness}/employees/$customerId',
      formdata,
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Customer Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteEmployee(var id) async {
    var res = await _apiService
        .delete('/businesses/${globals.selectedBusiness}/employees/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Customer Deleted Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> sendMessage(var data) async {
    var res = await _apiService.post(
        '/businesses/${globals.selectedBusiness}/employees/sms', data, false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Successfull, request being processed');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  // Future<ResponseModel> getCustomerInsight(String url,var data) async {
  //   var res = await _apiService.post(
  //       '/businesses/${globals.selectedBusiness}/customers/sms', data, false);
  //   if (res.statusCode == 200 || res.statusCode == 201) {
  //     return ResponseModel(
  //         isSuccess: true, response: 'Successfull, request being processed');
  //   } else {
  //     return ResponseModel(isSuccess: false, response: res.statusCode);
  //   }
  // }
}
