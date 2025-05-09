import 'dart:convert';

import '../../../exports.dart';
import '../../../utils/globals/global.dart' as globals;
import 'package:dio/dio.dart' as dio;

class ProductsRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<ProductsModel?> getAllProducts() async {
    ProductsModel? productsModel;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/products', false);
    if (res.statusCode == 200) {
      productsModel = ProductsModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return productsModel;
  }

  Future<ProductsModelRow?> getProductDetail(String id) async {
    ProductsModelRow? productsModelRow;

    var res = await _apiService.get(
        '/businesses/${globals.selectedBusiness}/products/$id', false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      productsModelRow =
          ProductsModelRow.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return productsModelRow;
  }

  Future<ResponseModel> addProduct(
    var data,
  ) async {
    var formdata = dio.FormData.fromMap(data);

    var res = await _apiService.post(
        '/businesses/${globals.selectedBusiness}/products', formdata, false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Product Added Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> editProduct(
    String customerId,
    var data,
  ) async {
    var formdata = dio.FormData.fromMap(data);
    var res = await _apiService.put(
        '/businesses/${globals.selectedBusiness}/products/$customerId',
        formdata);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Product Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }

  Future<ResponseModel> deleteProduct(var id) async {
    var res = await _apiService
        .delete('/businesses/${globals.selectedBusiness}/products/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Product Deleted Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }
}
