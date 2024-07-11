import 'dart:io';

import 'package:attenapp/cors/theme/textStyle.dart';
import 'package:attenapp/cors/utils/leaveApi.dart';
import 'package:attenapp/cors/widget/SizedBoxHeight10.dart';
import 'package:attenapp/cors/widget/SizedBoxHight20.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

const List<String> list = <String>['CASUAL', 'SICK', 'ANNUAL'];

class Leave extends StatefulWidget {
  const Leave({super.key});

  @override
  State<Leave> createState() => _LeaveState();
}

class _LeaveState extends State<Leave> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _controllerReason = TextEditingController();
  final TextEditingController _controllerDayStart = TextEditingController();
  final TextEditingController _controllerDayEnd = TextEditingController();
  String dropdownValue = list.first;
  XFile? pickedFile;
  late String file = "";
  bool fileUploaded = false;

  int leaveDays = 0;
  List<DateTime> weekendsAndHolidays = [];

  Future _selectStartDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(
          () => _controllerDayStart.text = picked.toString().split(" ")[0]);
    }
  }

  Future _selectEndDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() => _controllerDayEnd.text = picked.toString().split(" ")[0]);
      _calculateLeaveDays();
    }
  }

  List<DateTime> _getAllDatesBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> dateArray = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      dateArray
          .add(DateTime(currentDate.year, currentDate.month, currentDate.day));
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return dateArray;
  }

  void _calculateLeaveDays() {
    if (_controllerDayStart.text.isEmpty || _controllerDayEnd.text.isEmpty) {
      return;
    }

    DateTime startDate = DateTime.parse(_controllerDayStart.text);
    DateTime endDate = DateTime.parse(_controllerDayEnd.text);

    List<DateTime> dates = _getAllDatesBetween(startDate, endDate);
    List<DateTime> weekendsAndHolidays = [];

    for (var date in dates) {
      int day = date.weekday;

      if (day == DateTime.saturday || day == DateTime.friday) {
        weekendsAndHolidays.add(date);
      }
    }

    setState(() {
      leaveDays = dates.length - weekendsAndHolidays.length;
      this.weekendsAndHolidays = weekendsAndHolidays;
    });
  }

  Future _leaveApply({type, reason, dayStart, dayEnd, file}) async {
    try {
      final res =
          await LeaveService().leaveApply(type, reason, dayStart, dayEnd, file);

      if (res == null) {
        throw Exception('Response is null');
      }

      if (res["ok"] == true) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Leave Apply Successful")));
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
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: ListView(
          children: [
            const SizedBoxHeight20(),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyles.regular16,
                  ),
                );
              }).toList(),
            ),
            const SizedBoxHeight10(),
            TextFormField(
              controller: _controllerReason,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Enter Your Reasons",
                prefixIcon: const Icon(Icons.question_mark_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter Your Reason";
                }
                return null;
              },
            ),
            const SizedBoxHeight10(),
            TextFormField(
              readOnly: true,
              onTap: () {
                _selectStartDate();
              },
              controller: _controllerDayStart,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: "Start Date Pick",
                prefixIcon: const Icon(Icons.calendar_month_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter Date";
                }
                return null;
              },
            ),
            const SizedBoxHeight10(),
            TextFormField(
              readOnly: true,
              onTap: () {
                _selectEndDate();
              },
              controller: _controllerDayEnd,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: "End Date Pick",
                prefixIcon: const Icon(Icons.calendar_month_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter Date";
                }
                return null;
              },
            ),
            const SizedBoxHeight20(),
            customeDynamicLeaveCountWidget(),
            Visibility(
                visible: pickedFile != null,
                child: pickedFile != null
                    ? Image.file(
                        File(pickedFile!.path),
                        height: 300,
                        width: 300,
                      )
                    : Container()),
            const SizedBoxHeight20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    )),
                    onPressed: () {
                      checkPermission('camera');
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Take Picture',
                          style: TextStyles.regular12
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    )),
                    onPressed: () {
                      checkPermission('gallery');
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Gallary Picture',
                          style: TextStyles.regular12
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color(0xff2a225d),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (fileUploaded == false) {
                        _leaveApply(
                            type: dropdownValue,
                            reason: _controllerReason.text,
                            dayStart: _controllerDayStart.text,
                            dayEnd: _controllerDayEnd.text,
                            file: file);
                      }
                    }
                  },
                  child: Text(
                    fileUploaded ? "Loading..." : "Apply",
                    style: TextStyles.regular14.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBoxHeight20(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customeDynamicLeaveCountWidget() {
    if (leaveDays == 0) {
      return Container();
    }
    return Text(
      'Total Leave Days: $leaveDays',
      style: TextStyles.regular12,
    );
  }

  checkPermission(selectPic) async {
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.storage,
    ].request();
    if (status[Permission.camera] != PermissionStatus.granted ||
        status[Permission.storage] != PermissionStatus.granted) {
      return;
    }
    pickedImage(selectPic);
  }

  pickedImage(selectPic) async {
    final picker = ImagePicker();
    if (selectPic == 'camera') {
      pickedFile = await picker.pickImage(source: ImageSource.camera);

      final response = await LeaveService().uploadimage(pickedFile);
      setState(() {
        fileUploaded = true;
      });
      if (response != null && response['ok'] == true) {
        setState(() {
          file = response['imagePath'];
          fileUploaded = false;
        });
      }

      setState(() {
        fileUploaded = false;
      });
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      final response = await LeaveService().uploadimage(pickedFile);
      setState(() {
        fileUploaded = true;
      });
      if (response != null && response['ok'] == true) {
        setState(() {
          file = response['imagePath'];
          fileUploaded = false;
        });
      }
      setState(() {
        fileUploaded = false;
      });
    }
  }
}
