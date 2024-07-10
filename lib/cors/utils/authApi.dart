// ignore: file_names
import 'dart:convert';
import 'package:attenapp/cors/utils/appConstant.dart';

class Authentication {
  final url = AppConstant.baseUrl + AppConstant.loginUrl;

  Future<dynamic> signIn(email, password) async {
    final urlParse = Uri.parse(url);
    final body = {"email": email, "password": password};
    try {
      final response = await AppConstant().client.post(
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
      return e;
    } finally {
      AppConstant().client.close();
    }
  }
}
