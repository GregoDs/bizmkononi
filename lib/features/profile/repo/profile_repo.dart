import 'dart:convert';
import '../../../exports.dart';

import '../models/profile_model.dart';

class ProfileRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<ProfileModel?> getProfile() async {
    ProfileModel? salesModel;

    var res = await _apiService.get(
      '/auth/profile',
      false,
    );
    if (res.statusCode == 200) {
      salesModel = ProfileModel.fromJson(jsonDecode(jsonEncode(res.data)));
    }

    return salesModel;
  }

  Future<ResponseModel> editProfile(var data) async {
    var res = await _apiService.put('/auth/update', data);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ResponseModel(
          isSuccess: true, response: 'Profile Updated Successfully');
    } else {
      return ResponseModel(isSuccess: false, response: res.statusCode);
    }
  }
}
