import 'package:edriver/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../splashScreen/splash_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // FirebaseDatabase.instance.ref().child("test").set("hello");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
        },
        child: const Text("Logout"),
      ),
    );
  }
}
