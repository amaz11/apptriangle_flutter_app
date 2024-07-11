import 'package:attenapp/cors/theme/textStyle.dart';
import 'package:attenapp/cors/utils/appAssest.dart';
import 'package:attenapp/cors/utils/authApi.dart';
import 'package:attenapp/cors/widget/ProfileWidget.dart';
import 'package:attenapp/cors/widget/SizedBoxHeight10.dart';
import 'package:attenapp/cors/widget/SizedBoxHight20.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<dynamic> _profileFuture;
  @override
  void initState() {
    super.initState();
    _profileFuture = _getProfile();
  }

  Future<dynamic> _getProfile() async {
    try {
      final res = await Authentication().getProfile();
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
    return FutureBuilder(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final profile = snapshot.data!;
            return profileView(profile);
          } else {
            return const Center(child: Text("No data available"));
          }
        });
  }

  Widget profileImage(image) {
    if (image == null) {
      return Stack(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(profileImge)),
          ),
        ],
      );
    }
    return Stack(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network('http://192.168.0.102:8000/$image')),
        ),
      ],
    );
  }

  Widget profileView(profile) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            profileImage(profile['image']),
            const SizedBoxHeight10(),
            Text(
              profile["name"],
              style: TextStyles.title22,
            ),
            Center(
              child: Text(profile['email'],
                  style: TextStyles.regular14
                      .copyWith(fontWeight: FontWeight.w500)),
            ),
            const SizedBoxHeight20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileMenuWidget(
                    title: profile['phone'],
                    icon: Icons.phone_android_outlined),
                ProfileMenuWidget(
                    title: profile['position'], icon: Icons.portrait_sharp),
              ],
            ),
            ProfileMenuWidget(
                title: profile['address'], icon: Icons.place_outlined),
            const ProfileMenuWidget(
              title: "Logout",
              icon: Icons.logout_outlined,
              textColor: Colors.red,
              endIcon: false,
            ),
          ],
        ),
      ),
    );
  }
}
