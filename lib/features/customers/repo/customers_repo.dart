import 'dart:convert';

import 'package:biz_mkononi/features/customers/models/customers.dart';

import '../../../exports.dart';
import '../../../utils/globals/global.dart' as globals;
import 'package:dio/dio.dart' as dio;

class CustomersRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<CustomersModel?> getAllCustomers() async {
    CustomersModel? customersModel;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/customers', false);
    if (res.statusCode == 200) {
      customersModel =
          CustomersModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return customersModel;
  }

  Future<CustomersModelRow?> getCustomerDetail(String id) async {
    CustomersModelRow? customersModelRow;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/customers/$id', false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      customersModelRow =
          CustomersModelRow.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return customersModelRow;
  }

  Future<ResponseModel> addCustomer(
      var data,) async {
    var formdata = dio.FormData.fromMap(data);

    var res = await _apiService.post(
        '/businesses/${globals.selectedBusiness}/customers', formdata, false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Customer Added Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editCustomer(
    String customerId,
    var data,
  ) async {
    

    var formdata = dio.FormData.fromMap(data);
    var res = await _apiService.put(
      '/businesses/${globals.selectedBusiness}/customers/$customerId',
      formdata,
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
        isSuccess: true,
        response: 'Customer Updated Successfully',
      );
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteCustomer(var id) async {
    var res = await _apiService
        .delete('/businesses/${globals.selectedBusiness}/customers/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Customer Deleted Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> sendMessage(var data) async {
    var res = await _apiService.post(
        '/businesses/${globals.selectedBusiness}/customers/sms', data, false);
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
