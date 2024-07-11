import 'package:attenapp/cors/theme/textStyle.dart';
import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData? icon;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(
            width: 30,
          ),
          Text(
            title,
            style: TextStyles.regular14,
          ),
        ],
      ),
    );
  }
}
