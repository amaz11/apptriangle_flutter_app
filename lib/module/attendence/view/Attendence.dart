import 'package:attenapp/cors/theme/textStyle.dart';
import 'package:attenapp/cors/utils/attendenceApi.dart';
import 'package:attenapp/cors/widget/SizedBoxHight20.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendence extends StatefulWidget {
  const Attendence({super.key});

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late String lat;
  late String lon;

  late SharedPreferences prefs;

  bool isCheckInComplete = false;
  bool isCheckOutComplete = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    controller.addListener(() {
      setState(() {});
    });
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    final todayAttendence = await AttendenceService().todayAttendence();
    if (todayAttendence["data"].length > 0) {
      final bool? isCheckIn = prefs.getBool("isCheckInComplete");
      final bool? isCheckOut = prefs.getBool("isCheckOutComplete");
      final currrent = DateTime.now();
      final int currentHour = currrent.hour;
      setState(() {
        if (isCheckIn != null) {
          if (currentHour >= 18) {
            isCheckInComplete = true;
          } else if (isCheckIn == true) {
            isCheckInComplete = true;
          } else {
            isCheckInComplete = false;
          }
        }
      });
      if (currentHour >= 0 || currentHour < 18) {
        prefs.setBool("isCheckOutComplete", false);
      } else if (isCheckOut != null && isCheckOut == true) {
        setState(() {
          if (currentHour >= 18) {
            isCheckOutComplete = false;
          } else {
            isCheckOutComplete = true;
          }
        });
      }
    } else {
      setState(() {
        isCheckInComplete = false;
        isCheckOutComplete = false;
      });
      prefs.setBool("isCheckInComplete", false);
      prefs.setBool("isCheckOutComplete", false);
    }
  }

//
  bool _shouldShowCheckIn() {
    final current = DateTime.now();
    final checkInTime =
        DateTime(current.year, current.month, current.day, 9, 45);
    final checkOutTime =
        DateTime(current.year, current.month, current.day, 18, 0);
    return current.isAfter(checkInTime) &&
        !isCheckInComplete &&
        current.isBefore(checkOutTime);
  }

  bool _shouldShowCheckOut() {
    final current = DateTime.now();
    final checkOutTime =
        DateTime(current.year, current.month, current.day, 18, 0);
    return current.isAfter(checkOutTime) && !isCheckOutComplete;
  }

// Current Location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        lat = '${position.latitude}';
        lon = '${position.longitude}';
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

// Submit Attendence
  Future<void> _submitCheckIn() async {
    DateTime nowTime = DateTime.now();
    int checkInHour = nowTime.hour;
    int checkInMinutes = nowTime.minute;
    try {
      final res = await AttendenceService()
          .attendence(lat, lon, checkInHour, checkInMinutes);
      if (res == null) {
        throw Exception('Response is null');
      }
      if (res["ok"] == true) {
        setState(() {
          isCheckInComplete = true;
        });
        prefs.setBool("isCheckInComplete", true);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Attendence Submit Successfully")));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res['error'])));
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  Future<void> _submitCheckOut() async {
    DateTime nowTime = DateTime.now();
    int checkOutHour = nowTime.hour;
    int checkOutMinutes = nowTime.minute;
    try {
      final res = await AttendenceService()
          .attendenceCheckOut(checkOutHour, checkOutMinutes);
      if (res == null) {
        throw Exception('Response is null');
      }
      if (res["ok"] == true) {
        setState(() {
          isCheckOutComplete = true;
        });
        prefs.setBool("isCheckOutComplete", true);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Attendence Submit Successfully")));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res['error'])));
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [conditionalCheckInAndCheckOut()],
      ),
    );
  }

  Widget conditionalCheckInAndCheckOut() {
    if (_shouldShowCheckIn()) {
      return GestureDetector(
        onTapDown: (_) async {
          controller.forward();
          await _getCurrentLocation();
        },
        onTapUp: (_) async {
          if (controller.status == AnimationStatus.forward) {
            controller.reverse();
          }
          if (controller.isCompleted) {
            await _submitCheckIn();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: controller.value,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            Center(
              child: Text(
                "Hold on\n Check In",
                style: TextStyles.title22,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else if (_shouldShowCheckOut()) {
      return GestureDetector(
        onTapDown: (_) async {
          controller.forward();
          await _getCurrentLocation();
        },
        onTapUp: (_) async {
          if (controller.status == AnimationStatus.forward) {
            controller.reverse();
          }
          if (controller.isCompleted) {
            await _submitCheckOut();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: controller.value,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            Text(
              "Hold on\n Check Out",
              style: TextStyles.title22.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
    return Column(
      children: [
        Text(
          "Your Apply is Complete",
          style: TextStyles.title16,
        ),
        const SizedBoxHeight20(),
        SizedBox(
          width: 180,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color(0xff2a225d),
              ),
              onPressed: () {
                initSharedPreferences();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.refresh,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Refresh Screen",
                    style: TextStyles.regular12.copyWith(color: Colors.white),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
