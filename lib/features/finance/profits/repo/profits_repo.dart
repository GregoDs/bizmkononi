import '../../../../exports.dart';

class ProfitInsightRepo {
  final ApiService _apiService =
      ApiService(dotenv.env['PROD_ENDPOINT'].toString());

  Future<ResponseModel> getProfitInsights(String url, var data) async {
    var res = await _apiService.getInsightsDataDio(url, data);
    
    if (res.statusCode == 200) {
      
      return ResponseModel(isSuccess: true, response: res.data);
    }

    return ResponseModel(isSuccess: false, response: res.statusCode);
  }
}
