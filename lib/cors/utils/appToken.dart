import 'package:shared_preferences/shared_preferences.dart';

class Apptoken {
  Future<String?> getjwt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }
}
