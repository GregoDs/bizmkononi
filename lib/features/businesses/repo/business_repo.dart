import 'dart:convert';
import '../../../exports.dart';
import 'package:dio/dio.dart' as dio;

class BusinessesRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<BusinessModel?> getBusinessses() async {
    BusinessModel? businessModel;

    var res = await _apiService.get('/businesses', false);
    if (res.statusCode == 200) {
      businessModel = BusinessModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return businessModel;
  }

  Future<BusinessModelRows?> getSingleBusiness(String id) async {
    BusinessModelRows? businessModel;

    var res = await _apiService.get('/businesses/$id', false);
    if (res.statusCode == 200) {
      businessModel =
          BusinessModelRows.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return businessModel;
  }

//Add business section
  Future<ResponseModel> addBusiness(
    var data,
  ) async {
    var formdata = dio.FormData.fromMap(data);

    var res = await _apiService.post(
      '/businesses',
      formdata,
      false,
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
        isSuccess: true,
        response: 'Business Added Successfully',
      );
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editBusiness(
      String id, var data,) async {
       

    var formdata = dio.FormData.fromMap(data);
    var res = await _apiService.put(
        '/businesses/$id', formdata);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Business Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteBusiness(var id) async {
    var res = await _apiService
        .delete('/businesses/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Business Deleted Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }
}
