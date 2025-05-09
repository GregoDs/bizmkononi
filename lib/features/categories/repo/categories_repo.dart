import 'dart:convert';

import '../../../exports.dart';
import '../../../utils/globals/global.dart' as globals;
import 'package:dio/dio.dart' as dio;

import '../models/category_model.dart';

class CategoriesRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<CategoryModel?> getAllCategories() async {
    CategoryModel? categoryModel;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/categories', false);
    if (res.statusCode == 200) {
      categoryModel = CategoryModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return categoryModel;
  }

  Future<CategoryModelRow?> getCategoryDetail(String id) async {
    CategoryModelRow? categoryModelRow;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/categories/$id', false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      categoryModelRow =
          CategoryModelRow.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return categoryModelRow;
  }

  Future<ResponseModel> addCategory(
      var data,) async {
    var formdata = dio.FormData.fromMap(data);

    var res = await _apiService.post(
        '/businesses/${globals.selectedBusiness}/categories', formdata, false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Category Added Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editCategory(
      String customerId, var data,) async {
    

    var formdata = dio.FormData.fromMap(data);
    var res = await _apiService.put(
      '/businesses/${globals.selectedBusiness}/categories/$customerId',
      formdata,
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Category Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteCategory(var id) async {
    var res = await _apiService
        .delete('/businesses/${globals.selectedBusiness}/categories/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Category Deleted Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }
}
