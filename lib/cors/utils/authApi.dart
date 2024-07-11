// ignore: file_names
import 'dart:convert';
import 'package:attenapp/cors/utils/appConstant.dart';
import 'package:http/http.dart' as http;

class Authentication {
  final url = AppConstant.baseUrl + AppConstant.loginUrl;
  final client = http.Client();

  Future<dynamic> signIn(email, password) async {
    final urlParse = Uri.parse(url);
    final body = {"email": email, "password": password};
    print(body);
    try {
      final response = await client.post(
        urlParse,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      if (response.statusCode == 400) {
        return jsonDecode(response.body);
      }
      if (response.statusCode == 404) {
        return jsonDecode(response.body);
      }
      // print('Request failed with status: ${jsonDecode(response.body)}');
      return null;
    } catch (e) {
      print(e);
      return e;
    } finally {
      client.close();
    }
  }
}
