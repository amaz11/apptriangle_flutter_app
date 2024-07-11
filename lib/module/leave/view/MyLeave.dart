import 'package:attenapp/cors/theme/textStyle.dart';
import 'package:attenapp/cors/utils/appAssest.dart';
import 'package:attenapp/cors/utils/leaveApi.dart';
import 'package:attenapp/cors/widget/ImageWidget.dart';
import 'package:attenapp/cors/widget/Sidebar.dart';
import 'package:attenapp/cors/widget/SizedBoxHeight10.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MyLeave extends StatefulWidget {
  const MyLeave({super.key});

  @override
  State<MyLeave> createState() => _MyLeaveState();
}

class _MyLeaveState extends State<MyLeave> {
  late Future<dynamic> _leaveFuture;

  @override
  void initState() {
    super.initState();
    _leaveFuture = _getLeaveForEmployees();
  }

  Future<dynamic> _getLeaveForEmployees() async {
    try {
      final res = await LeaveService().getLeaveForEmployee();
      // print(res);
      if (res == null) {
        throw Exception('Response is null');
      }
      if (res["ok"]) {
        return res["data"];
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("All Leaves"),
        ),
        drawer: const Sidebar(),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: FutureBuilder(
                  future: _leaveFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      final leavearr = snapshot.data!;
                      if (leavearr.length == 0) {
                        return const Center(child: Text("No data available"));
                      }
                      return listView(leavearr);
                    } else {
                      return const Center(child: Text("No data available"));
                    }
                  },
                ))));
  }

  Widget listView(List leaveArr) {
    Color getRandomColor() {
      Random random = Random();
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }

    Widget actionButton(admin, teamLead) {
      if (admin == "ACCEPTED" ||
          admin == "REJECTED" ||
          teamLead == "ACCEPTED" ||
          teamLead == "REJECTED") {
        return Container();
      }
      return const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.edit_outlined, size: 20),
          SizedBox(
            width: 16,
          ),
          Icon(
            Icons.delete_outlined,
            size: 20,
          ),
        ],
      );
    }

    Widget imageFile(image) {
      if (image.length > 0) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: GestureDetector(
              child: SizedBox(
                  width: 100, height: 100, child: Image.asset(imageIcon)),
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (_) => ImageDialog(image: image));
              },
            ));
      }
      return Container();
    }

    Widget rejectReason(name, reason, status) {
      if (reason == null) {
        return Container();
      }
      if (status == "ACCEPTED") {
        return Container();
      }
      if (reason.length != 0) {
        return Row(children: [
          Text("$name: ",
              style:
                  TextStyles.regular12.copyWith(fontWeight: FontWeight.w500)),
          Text(reason.toString(),
              style: TextStyles.regular12.copyWith(fontWeight: FontWeight.w600))
        ]);
      }
      return Container();
    }

    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 16,
            ),
        padding: const EdgeInsets.only(bottom: 30),
        itemCount: leaveArr.length,
        itemBuilder: (BuildContext context, int index) {
          final leave = leaveArr[index];
          return Container(
            padding: const EdgeInsets.only(
                left: 10.0, top: 10.0, right: 15.0, bottom: 10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(9, 0, 0, 0),
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
                border: Border(
                    left: BorderSide(color: getRandomColor(), width: 5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Leave Type: ",
                        style: TextStyles.regular12
                            .copyWith(fontWeight: FontWeight.w500)),
                    Text(leave["type"],
                        style: TextStyles.regular12
                            .copyWith(fontWeight: FontWeight.w600))
                  ],
                ),
                const SizedBoxHeight10(),
                Text(
                  leave["reason"],
                  style: TextStyles.regular12,
                ),
                const SizedBoxHeight10(),
                Center(child: imageFile(leave["file"])),
                const SizedBoxHeight10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Start: ",
                            style: TextStyles.regular12
                                .copyWith(fontWeight: FontWeight.w500)),
                        Text(leave["dayStart"].toString().split("T")[0],
                            style: TextStyles.regular12
                                .copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("End: ",
                            style: TextStyles.regular12
                                .copyWith(fontWeight: FontWeight.w500)),
                        Text(leave["dayEnd"].toString().split("T")[0],
                            style: TextStyles.regular12
                                .copyWith(fontWeight: FontWeight.w600))
                      ],
                    ),
                  ],
                ),
                const SizedBoxHeight10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Admin Approval: ",
                          style: TextStyles.regular12
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          leave["adminStatus"],
                          style: TextStyles.regular12.copyWith(
                              fontWeight: FontWeight.w600,
                              color: leave["adminStatus"] == "ACCEPTED"
                                  ? Colors.green[600]
                                  : leave["adminStatus"] == "PENDING"
                                      ? Colors.red[300]
                                      : Colors.red[600]),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "TL Approval: ",
                          style: TextStyles.regular12
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(leave["status"],
                            style: TextStyles.regular12.copyWith(
                                fontWeight: FontWeight.w600,
                                color: leave["status"] == "ACCEPTED"
                                    ? Colors.green[600]
                                    : leave["status"] == "PENDING"
                                        ? Colors.red[300]
                                        : Colors.red[600]))
                      ],
                    ),
                  ],
                ),
                rejectReason(
                    "Admin Note", leave["noteAdmin"], leave["adminStatus"]),
                const SizedBoxHeight10(),
                rejectReason("TL Note", leave["noteHead"], leave["status"]),
                const SizedBoxHeight10(),
                actionButton(leave["adminStatus"], leave["status"])
              ],
            ),
          );
        });
  }
}
