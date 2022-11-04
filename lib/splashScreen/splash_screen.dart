import 'dart:async';
import 'package:edriver/authentication/images/uploadPhoto.dart';
import 'package:edriver/authentication/login_screen.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/mainScreens/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() async {
    Timer(const Duration(seconds: 3), () async {
      if (fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (c) => Home()));
      } else {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
        // send user to home screen
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo2.png"),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
