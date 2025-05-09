import '../../exports.dart';
import 'package:dio/dio.dart' as dio;

Dio dioInstance = Dio();

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<dio.Response> post(String endpoint, var body, bool isAuth) async {
    Map<String, String> headers = {};
    String? retrievedToken = await getToken();
    print("Retrieved token in post is : $retrievedToken");
    headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    if (!isAuth) {
      headers['Authorization'] = 'Bearer $retrievedToken';
    }
    return await dioInstance.post(
      baseUrl + endpoint,
      options: Options(
        headers: headers,
      ),
      data: body,
    );

    // print(retrievedToken);

    // headers.addAll({
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    // });
    // if (!isAuth) {
    //   headers['Authorization'] = 'Bearer $retrievedToken';
    // }

    // Uri uri = Uri.parse('$baseUrl$endpoint');
    // final response =
    //     await http.post(uri, headers: headers, body: jsonEncode(body));

    // return response;
  }

  Future<dio.Response> get(String endpoint, bool isAuth) async {
    Map<String, String> headers = {};
    String? retrievedToken = await getToken();

    headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (!isAuth) {
      headers['Authorization'] = 'Bearer $retrievedToken';
    }

    return await dioInstance.get(
      baseUrl + endpoint,
      options: Options(
        headers: headers,
      ),
    );

    // final response =
    //     await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);

    // if (response.statusCode == 200) {
    //   return response;
    // } else {
    //   return response;
    // }
  }

  Future<dio.Response> put(String endpoint, var body) async {
    Map<String, String> headers = {};
    String? retrievedToken = await getToken();
    print('Retrieved Token: $retrievedToken');

    headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $retrievedToken'
    });

    return await dioInstance.put(
      baseUrl + endpoint,
      options: Options(
        headers: headers,
      ),
      data: body,
    );

    // Uri uri = Uri.parse('$baseUrl$endpoint');
    // final response =
    //     await http.put(uri, headers: headers, body: jsonEncode(body));

    // return response;
  }

  Future<dio.Response> delete(String endpoint) async {
    Map<String, String> headers = {};
    String? retrievedToken = await getToken();

    headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $retrievedToken'
    });

    return await dioInstance.delete(
      baseUrl + endpoint,
      options: Options(
        headers: headers,
      ),
    );

    // Uri uri = Uri.parse('$baseUrl$endpoint');
    // final response = await http.delete(uri, headers: headers);

    // return response;
  }

  // Future<http.Response> getInsightsData(String endpoint, var data) async {
  //   Map<String, String> headers = {};
  //   String? retrievedToken = await getToken();

  //   headers.addAll({
  //     'Content-Type': 'application/json;charset=UTF-8',
  //     // 'Charset': 'utf-8',
  //     // 'Accept': 'application/json',
  //     // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  //     // "Access-Control-Allow-Credentials": true,
  //     'Authorization': 'Bearer $retrievedToken',
  //   });

  //   var uri = Uri.parse('$baseUrl$endpoint');
  //   uri = uri.replace(
  //       query: jsonEncode({
  //     'group': 'day',
  //     'from': '2024-03-15 00:00:00.000',
  //     'to': '2024-04-15 07:18:51.422101',
  //     'tz': '3:00:00.000000'
  //   }));
  //   final response = await http.get(
  //       Uri.parse(
  //           'https://api-stage.mkononi.biz/businesses/53de37c0-233a-4c65-ab09-4e9f44f21b9f/sales-analytics/sales-trend?%7Bgroup:%20month,%20from:%202023-09-15%2000:00:00.000,%20to:%202024-04-15%2007:18:51.422101,%20tz:%203:00:00.000000%7D'),
  //       headers: headers);

  //   print(uri);
  //   print(data);
  //   print(response.statusCode);
  //   print(response.body);

  //   return response;
  // }

  Future<dio.Response> getInsightsDataDio(String endpoint, var data) async {
    Map<String, String> headers = {};
    String? retrievedToken = await getToken();

    headers.addAll({
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $retrievedToken',
    });

    return await dioInstance.get(
      baseUrl + endpoint,
      queryParameters: data,
      options: Options(
        responseType: ResponseType.plain,
        headers: headers,
      ),
    );
  }
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("auth_token");
  print('Retrieved token from SharedPreferences: $token');
  return prefs.getString('auth_token');
}

Future<void> saveData(String id, String email, String phone, String name,
    String password, String jwt) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', jwt);
  print('Token saved: $jwt'); // Log the token when it is saved
}
