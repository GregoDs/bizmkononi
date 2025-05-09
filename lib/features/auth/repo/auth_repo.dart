import 'dart:convert';
import 'dart:developer';

import '../../../exports.dart';

class AuthRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<ResponseModel> login(var data) async {
    ResponseModel? responseModel;
    try {
      var res = await _apiService.post('/auth/login', data, true);
      log('Error: $res');
      if (res.statusCode == 200 || res.statusCode == 201) {
        UserModel userModel =
            UserModel.fromJson(jsonDecode(jsonEncode(res.data)));
        await saveData(
          userModel.user!.id!,
          userModel.user!.email!,
          data['phone'],
          userModel.user!.name!,
          data['password'],
          userModel.jwt!,
        );
        return ResponseModel(
          isSuccess: true,
          response: 'Welcome ${userModel.user!.name!}',
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          return ResponseModel(
            isSuccess: false,
            response: 'Wrong Phone Number or Password',
          );
        }
        if (e.response?.statusCode == 400) {
          return ResponseModel(
            isSuccess: false,
            response: 'Account does not Exist',
          );
        }
      }
      responseModel = ResponseModel(
        isSuccess: false,
        response: e.toString(),
      );
    }

    return responseModel!;
  }

  // Future<ResponseModel> login1(var data) async {
  //   ResponseModel? responseModel;
  //   try {
  //     var res = await _apiService.post('/auth/login', data, true);
  //     if (res.statusCode == 200 || res.statusCode == 201) {
  //       UserModel userModel =
  //           UserModel.fromJson(jsonDecode(jsonEncode(res.data)));
  //       await saveData(
  //         userModel.user!.id!,
  //         userModel.user!.email!,
  //         data['phone'],
  //         userModel.user!.name!,
  //         data['password'],
  //         userModel.jwt!,
  //       );
  //       responseModel = ResponseModel(
  //         isSuccess: true,
  //         response: 'Welcome ${userModel.user!.name!}',
  //       );
  //     }
  //     // else {
  //     //   responseModel = ResponseModel(
  //     //     isSuccess: false,
  //     //     response: 'Oops Something went wrong',
  //     //   );
  //     // }
  //   } catch (e) {
  //     if (e is DioException) {
  //       if (e.response?.data == null) {
  //         responseModel = ResponseModel(
  //           isSuccess: false,
  //           response: 'Oops Something went wrong',
  //         );
  //       } else if (e.response?.statusCode == 403) {
  //         responseModel = ResponseModel(
  //           isSuccess: false,
  //           response:
  //               'This account does not exist/Is code is already resent.Please Verify',
  //         );
  //       } else if (e.response?.statusCode == 400) {
  //         responseModel = ResponseModel(
  //           isSuccess: false,
  //           response:
  //               'This phone number has already been Verified.Please Login.',
  //         );
  //       }
  //     } else {
  //       responseModel = ResponseModel(
  //         isSuccess: false,
  //         response: 'Oops Something went wrong',
  //       );
  //     }
  //   }

  //   return responseModel!;
  // }

  Future<ResponseModel> register(var data) async {
    ResponseModel? responseModel;
    try {
      var res = await _apiService.post('/auth/register', data, true);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ResponseModel(
          isSuccess: true,
          response: 'Registration Success\nPlease Verify you number',
        );
      } else {
        responseModel = ResponseModel(
          isSuccess: false,
          response: 'Oops Something went wrong',
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data == null) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'Oops Something went wrong',
          );
        } else if (e.response?.statusCode == 403) {
          responseModel = ResponseModel(
            isSuccess: false,
            response:
                'This phone number has already been registered. Please login or change password if you have forgotten your password',
          );
        } else if (e.response?.statusCode == 400) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'Bad request. Please ensure all fields have valid data.',
          );
        }
      } else {
        responseModel = ResponseModel(
          isSuccess: false,
          response: 'Oops Something went wrong',
        );
      }
    }
    return responseModel!;
  }

  Future<ResponseModel> resendCode(var data) async {
    ResponseModel? responseModel;
    try {
      var res = await _apiService.post('/auth/verify/resend', data, true);
      if (res.statusCode == 200 || res.statusCode == 201) {
        responseModel = ResponseModel(
          isSuccess: true,
          response: 'Code sent Successfully',
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data == null) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'Oops Something went wrong',
          );
        } else if (e.response?.statusCode == 403) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'This account has already been verified. Please login',
          );
        } else if (e.response?.statusCode == 400) {
          responseModel = ResponseModel(
            isSuccess: false,
            response:
                'This phone number has already been Verified.Please Login.',
          );
        }
      } else {
        responseModel = ResponseModel(
          isSuccess: false,
          response: 'Oops Something went wrong',
        );
      }
    }

    return responseModel!;
  }

  Future<ResponseModel> verifyCode(var data) async {
    ResponseModel? responseModel;
    try {
      var res = await _apiService.post('/auth/verify', data, true);
      if (res.statusCode == 200 || res.statusCode == 201) {
        responseModel = ResponseModel(
          isSuccess: true,
          response: 'Code sent Successfully',
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data == null) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'Oops Something went wrong',
          );
        } else if (e.response?.statusCode == 403) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'This Code does not exist',
          );
        } else if (e.response?.statusCode == 400) {
          responseModel = ResponseModel(
            isSuccess: false,
            response:
                'This phone number has already been Verified.Please Login.',
          );
        }
      } else {
        responseModel = ResponseModel(
          isSuccess: false,
          response: 'Oops Something went wrong',
        );
      }
    }

    return responseModel!;
  }

  Future<ResponseModel> forgotPassword(var data) async {
    ResponseModel? responseModel;
    try {
      var res = await _apiService.post('/auth/forgot-password', data, true);
      if (res.statusCode == 200 || res.statusCode == 201) {
        responseModel = ResponseModel(
          isSuccess: true,
          response: 'Code sent Successfully',
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data == null) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'Oops Something went wrong',
          );
        } else if (e.response?.statusCode == 403) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'This Code does not exist',
          );
        } else if (e.response?.statusCode == 400) {
          responseModel = ResponseModel(
            isSuccess: false,
            response:
                'This phone number has already been Verified.Please Login.',
          );
        }
      } else {
        responseModel = ResponseModel(
          isSuccess: false,
          response: 'Oops Something went wrong',
        );
      }
    }

    return responseModel!;
  }

  Future<ResponseModel> resetPassword(var data) async {
    ResponseModel? responseModel;
    try {
      var res = await _apiService.post('/auth/reset-password', data, true);
      if (res.statusCode == 200 || res.statusCode == 201) {
        responseModel = ResponseModel(
          isSuccess: true,
          response: 'Code sent Successfully',
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data == null) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'Oops Something went wrong',
          );
        } else if (e.response?.statusCode == 403) {
          responseModel = ResponseModel(
            isSuccess: false,
            response: 'This Code does not exist',
          );
        } else if (e.response?.statusCode == 400) {
          responseModel = ResponseModel(
            isSuccess: false,
            response:
                'This phone number has already been Verified.Please Login.',
          );
        }
      } else {
        responseModel = ResponseModel(
          isSuccess: false,
          response: 'Oops Something went wrong',
        );
      }
    }

    return responseModel!;
  }

  Future<void> saveData(
    String userId,
    String email,
    String phone,
    String name,
    String password,
    String token,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('name', name);
    await prefs.setString('password', password);
    await prefs.setString('auth_token', token);
    await prefs.setBool('isLogin', true);
  }
}
