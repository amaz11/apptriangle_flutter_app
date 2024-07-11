import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  ImageDialog({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 500,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage('http://192.168.0.102:8000/$image'),
                fit: BoxFit.fill)),
      ),
    );
  }
}
