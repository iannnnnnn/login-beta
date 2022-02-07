import 'package:flutter/material.dart';
import 'package:udemy_course/UI/constant.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: Size.infinite.width,
        child: Center(
          child: Text(
            "Chill",
            style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.2),
          ),
        ),
      ),
    );
  }
}
