import 'package:http/http.dart' as http;

class AppConstant {
  static String get baseUrl => 'http://192.168.0.101:8000/api/v1';
  static String loginUrl = "/auth/login";
  static String attendence = "/attendence";
  static String leave = "/leaves";
  final client = http.Client();
}
