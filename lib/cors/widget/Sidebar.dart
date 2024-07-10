import 'package:attenapp/module/auth/view/Login.dart';
import 'package:attenapp/module/home/view/Home.dart';
import 'package:attenapp/module/leave/view/LeaveTeamLead.dart';
import 'package:attenapp/module/leave/view/MyLeave.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late Future<Map<String, dynamic>> decodedTokenFuture;
  @override
  void initState() {
    super.initState();
    decodedTokenFuture = initSharedPreferences();
  }

  Future<Map<String, dynamic>> initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token != null) {
      return JwtDecoder.decode(token);
    } else {
      throw Exception("Token not found");
    }
  }

  // ignore: non_constant_identifier_names
  Widget TeamLeaderSideBar(decoded) {
    if (decoded["role"] == "TEAMLEADER") {
      return ListTile(
        leading: const Icon(Icons.timelapse_sharp),
        title: const Text('TL Leaves'),
        onTap: () {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const Leaveteamlead()),
          );
        },
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: decodedTokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading token'));
          } else if (snapshot.hasData) {
            final decodedToken = snapshot.data!;
            return Drawer(
              backgroundColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text('Drawer Header'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.home_outlined),
                          title: const Text('Home'),
                          onTap: () {
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.av_timer_outlined),
                          title: const Text('My Leaves'),
                          onTap: () {
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyLeave()),
                            );
                          },
                        ),
                        TeamLeaderSideBar(decodedToken),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.output_outlined),
                    title: const Text('Log Out'),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("token", "");
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                  )
                ],
              ),
            );
          } else {
            return const Center(child: Text('No token found'));
          }
        });
  }
}
