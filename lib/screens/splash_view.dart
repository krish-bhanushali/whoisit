import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whoisit/screens/home_view.dart';
import 'package:whoisit/screens/intro_view.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        Future.delayed(Duration(seconds: 3)).then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => IntroScreen()));
        });
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
