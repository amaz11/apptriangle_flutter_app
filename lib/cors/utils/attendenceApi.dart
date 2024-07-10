import 'dart:convert';
import 'package:attenapp/cors/utils/appConstant.dart';
import 'package:attenapp/cors/utils/appToken.dart';

class AttendenceService {
  final url = AppConstant.baseUrl + AppConstant.attendence;
  Future<dynamic> attendence(lat, lon, checkInHour, checkInMinutes) async {
    final urlParse = Uri.parse(url);
    final body = {
      "lat": lat,
      "lon": lon,
      "checkInHour": checkInHour,
      "checkInMinutes": checkInMinutes
    };
    try {
      final token = await Apptoken().getjwt();
      final response = await AppConstant().client.post(
            urlParse,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(body),
          );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      if (response.statusCode == 400) {
        return jsonDecode(response.body);
      }
      if (response.statusCode == 404) {
        return jsonDecode(response.body);
      }
      if (response.statusCode == 401) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return e;
    } finally {
      AppConstant().client.close();
    }
  }

  Future<dynamic> attendenceCheckOut(checkOutHour, checkOutMinutes) async {
    final urlParse = Uri.parse(url);
    final body = {
      "checkOutHour": checkOutHour,
      "checkOutMinutes": checkOutMinutes
    };
    try {
      final token = await Apptoken().getjwt();

      final response = await AppConstant().client.patch(
            urlParse,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
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
      return null;
    } catch (e) {
      return null;
    } finally {
      AppConstant().client.close();
    }
  }
}
