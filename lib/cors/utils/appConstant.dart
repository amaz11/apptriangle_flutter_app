import 'package:http/http.dart' as http;

// https://apptriangle-node-backend.onrender.com/
class AppConstant {
  static String get baseUrl => 'http://192.168.0.102:8000/api/v1';
  static String loginUrl = "/auth/login";
  static String attendence = "/attendence";
  static String leave = "/leaves";
  static String file = "/file/image";
  static String profile = "/users/profile";
  final client = http.Client();
}
