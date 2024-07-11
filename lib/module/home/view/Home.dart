import 'package:attenapp/cors/widget/Sidebar.dart';
import 'package:attenapp/module/attendence/view/Attendence.dart';
import 'package:attenapp/module/leave/view/LeaveApply.dart';
import 'package:attenapp/module/profile/view/Profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static final List<Widget> _bottomNavBarOptions = <Widget>[
    const Attendence(),
    const Leave(),
    const Profile(),
  ];

  static const List<Widget> _appbarOption = <Widget>[
    Text("Attendence"),
    Text("Apply For Leave"),
    Text("Profile")
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appbarOption[_selectedIndex],
      ),
      body: SafeArea(
          child: Center(
        child: _bottomNavBarOptions.elementAt(_selectedIndex),
      )),
      drawer: const Sidebar(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_rounded),
            label: 'Attendence',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.av_timer_outlined),
            label: 'Leave',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff2a225d),
        onTap: _onItemTapped,
      ),
    );
  }
}
