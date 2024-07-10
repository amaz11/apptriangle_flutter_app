import 'dart:convert';
import 'package:attenapp/cors/utils/appConstant.dart';
import 'package:attenapp/cors/utils/appToken.dart';

class LeaveService {
  final leave = AppConstant.baseUrl + AppConstant.leave;

  Future<dynamic> leaveApply(type, reason, dayStart, dayEnd) async {
    final urlParse = Uri.parse(leave);
    final token = await Apptoken().getjwt();
    final body = {
      "type": type,
      "reason": reason,
      "dayStart": dayStart,
      "dayEnd": dayEnd
    };
    try {
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
      // print('Request failed with status: ${jsonDecode(response.body)}');
      return null;
    } catch (e) {
      // print('Error during sign-up request: $e');
      return e;
    } finally {
      AppConstant().client.close();
    }
  }

  Future<dynamic> getLeaveForEmployee() async {
    final url = Uri.parse('$leave/user');
    try {
      final token = await Apptoken().getjwt();
      final response = await AppConstant().client.get(
        url,
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
      if (response.statusCode == 401) {
        return jsonDecode(response.body);
      }
      // print('Request failed with status: ${jsonDecode(response.body)}');
      return null;
    } catch (e) {
      // print('Error during sign-up request: $e');
      return e;
    } finally {
      AppConstant().client.close();
    }
  }

  Future<dynamic> getLeaveForTL() async {
    final url = Uri.parse('$leave/team/leader');
    try {
      final token = await Apptoken().getjwt();

      final response = await AppConstant().client.get(
        url,
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
      if (response.statusCode == 401) {
        return jsonDecode(response.body);
      }
      // print('Request failed with status: ${jsonDecode(response.body)}');
      return null;
    } catch (e) {
      // print('Error during sign-up request: $e');
      return e;
    } finally {
      AppConstant().client.close();
    }
  }

  Future<dynamic> leaveStatusUpdateByTL(status, noteHead, id) async {
    final url = Uri.parse('$leave/team/leader/$id');
    final body = {"status": status, "noteHead": noteHead};

    try {
      final token = await Apptoken().getjwt();
      final response = await AppConstant().client.patch(
            url,
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
      if (response.statusCode == 401) {
        return jsonDecode(response.body);
      }
      // print('Request failed with status: ${jsonDecode(response.body)}');
      return null;
    } catch (e) {
      // print('Error during sign-up request: $e');
      return e;
    } finally {
      AppConstant().client.close();
    }
  }
}
