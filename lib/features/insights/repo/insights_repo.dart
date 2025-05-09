import '../../../exports.dart';
// import '../../../utils/globals/global.dart' as globals;

class InsightsRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<ResponseModel> getInsights(String url, var data) async {
    var res = await _apiService.getInsightsDataDio(url, data);
    
    if (res.statusCode == 200) {
      
      return ResponseModel(isSuccess: true, response: res.data);
    }

    return ResponseModel(isSuccess: false, response: res.statusCode);
  }
}
