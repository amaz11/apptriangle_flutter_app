// ignore: file_names
import 'dart:convert';
import 'package:attenapp/cors/utils/appConstant.dart';
import 'package:attenapp/cors/utils/appToken.dart';

class Authentication {
  final _url = AppConstant.baseUrl + AppConstant.loginUrl;
  final _profileUrl = AppConstant.baseUrl + AppConstant.profile;

  Future<dynamic> signIn(email, password) async {
    final urlParse = Uri.parse(_url);
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

  Future<dynamic> getProfile() async {
    final urlParse = Uri.parse(_profileUrl);

    try {
      final token = await Apptoken().getjwt();
      final response = await AppConstant().client.get(
        urlParse,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
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
