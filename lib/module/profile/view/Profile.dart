import 'package:attenapp/cors/theme/textStyle.dart';
import 'package:attenapp/cors/utils/appAssest.dart';
import 'package:attenapp/cors/widget/ProfileWidget.dart';
import 'package:attenapp/cors/widget/SizedBoxHeight10.dart';
import 'package:attenapp/cors/widget/SizedBoxHight20.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(profileImge)),
                ),
              ],
            ),
            const SizedBoxHeight10(),
            Text(
              "K M Amaz Uddin Shaon",
              style: TextStyles.title22,
            ),
            Center(
              child: Text("amaz10@gmail.com",
                  style: TextStyles.regular14
                      .copyWith(fontWeight: FontWeight.w500)),
            ),
            const SizedBoxHeight20(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileMenuWidget(
                    title: "Phone", icon: Icons.phone_android_outlined),
                ProfileMenuWidget(
                    title: "Position", icon: Icons.portrait_sharp),
              ],
            ),
            const ProfileMenuWidget(
                title: "Address", icon: Icons.place_outlined),
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
