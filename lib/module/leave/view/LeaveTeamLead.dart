import 'package:attenapp/cors/theme/textStyle.dart';
import 'package:attenapp/cors/utils/leaveApi.dart';
import 'package:attenapp/cors/widget/Sidebar.dart';
import 'package:attenapp/cors/widget/SizedBoxHeight10.dart';
import 'package:flutter/material.dart';
import 'dart:math';

const List<String> list = <String>['PENDING', 'ACCEPTED', 'REJECTED'];

class Leaveteamlead extends StatefulWidget {
  const Leaveteamlead({super.key});

  @override
  State<Leaveteamlead> createState() => _LeaveteamleadState();
}

class _LeaveteamleadState extends State<Leaveteamlead> {
  final TextEditingController _controllerNote = TextEditingController();
  late Future<dynamic> _leaveFuture;
  String dropdownValue = list.first;
  @override
  void initState() {
    super.initState();
    _leaveFuture = _getLeaveForTeamLead();
  }

  Future<dynamic> _getLeaveForTeamLead() async {
    try {
      final res = await LeaveService().getLeaveForTL();
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

  // ignore: non_constant_identifier_names
  Future<dynamic> _LeaveStatusUpdateByTeamLead({status, noteHead, id}) async {
    try {
      final res =
          await LeaveService().leaveStatusUpdateByTL(status, noteHead, id);
      // print(res);
      if (res == null) {
        throw Exception('Response is null');
      }
      if (res["ok"]) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Update Successful')));
        setState(() {
          _leaveFuture = _getLeaveForTeamLead();
        });
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
          title: const Text("Leave From Team"),
        ),
        drawer: const Sidebar(),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
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

    Widget resonField(localDropdownValue) {
      if (localDropdownValue == "REJECTED") {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextField(
            controller: _controllerNote,
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
          ),
        );
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
                Center(
                  child: Text(leave["applicant"]["name"].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                ),
                const SizedBoxHeight10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                            "Email: ",
                            style: TextStyles.regular12
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(leave["applicant"]["email"],
                              style: TextStyles.regular12
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ]),
                        const SizedBoxHeight10(),
                        Row(children: [
                          Text("Leave Type: ",
                              style: TextStyles.regular12
                                  .copyWith(fontWeight: FontWeight.w500)),
                          Text(leave["type"],
                              style: TextStyles.regular12
                                  .copyWith(fontWeight: FontWeight.w600))
                        ]),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("Start: ",
                                style: TextStyles.regular12
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Text(leave["dayStart"].toString().split("T")[0],
                                style: TextStyles.regular12
                                    .copyWith(fontWeight: FontWeight.w600))
                          ],
                        ),
                        const SizedBoxHeight10(),
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
                    )
                  ],
                ),
                const SizedBoxHeight10(),
                Center(
                    child: Text(leave["reason"], style: TextStyles.regular12)),
                const SizedBoxHeight10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Ad Ap: ",
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
                    const SizedBoxHeight10(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "TL Ap: ",
                              style: TextStyles.regular12
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              leave["status"],
                              style: TextStyles.regular12.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: leave["status"] == "ACCEPTED"
                                      ? Colors.green[600]
                                      : leave["status"] == "PENDING"
                                          ? Colors.red[300]
                                          : Colors.red[600]),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBoxHeight10(),
                rejectReason(
                    "Admin Note", leave["noteAdmin"], leave["adminStatus"]),
                const SizedBoxHeight10(),
                rejectReason("TL Note", leave["noteHead"], leave["status"]),
                const SizedBoxHeight10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            String localDropdownValue = dropdownValue;
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: SizedBox(
                                  height: 290,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        top: 30,
                                        bottom: 10),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          DropdownButtonFormField(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            isExpanded: true,
                                            value: dropdownValue,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                dropdownValue = value!;
                                                localDropdownValue =
                                                    dropdownValue;
                                              });
                                              // print(dropdownValue);
                                            },
                                            items: list
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                          resonField(localDropdownValue),
                                          const SizedBox(height: 30),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize:
                                                  const Size.fromHeight(50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text('Update Status'),
                                            onPressed: () {
                                              _LeaveStatusUpdateByTeamLead(
                                                  id: leave["id"],
                                                  status: localDropdownValue,
                                                  noteHead:
                                                      _controllerNote.text);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
