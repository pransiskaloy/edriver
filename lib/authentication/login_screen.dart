import 'package:edriver/authentication/signup_screen.dart';
import 'package:edriver/main.dart';
import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm(BuildContext context) {
    if (!emailTextEditingController.text.contains("@") ||
        !emailTextEditingController.text.contains(".")) {
      showToaster(context, "Please enter a valid email", 'fail');
    } else if (passwordTextEditingController.text.isNotEmpty) {
      if (passwordTextEditingController.text.length < 6) {
        showToaster(context, "Password must be at least 6 characters", 'fail');
      } else {
        loginDriver();
      }
    } else if (passwordTextEditingController.text.isEmpty) {
      showToaster(context, "Password is required", 'fail');
    }
  }

  loginDriver() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(
          message: "Processing . . .",
        );
      },
    );
    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      // showToaster(context, "Error: " + msg.toString(), 'fail');
      showToaster(context, "Account not found", 'fail');
    }))
        .user;
    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;

          MyApp.restartApp(context);
        } else {
          fAuth.signOut();
          showToaster(context, "No record exist with this credential.", "fail");
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const LoginScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      showToaster(context, "Error occurred during Login.", "fail");
    }
  }

  void showToaster(BuildContext context, String str, String status) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          str,
          style: status == "success"
              ? const TextStyle(color: Colors.green, fontSize: 15)
              : const TextStyle(color: Colors.red, fontSize: 15),
        ),
        action: SnackBarAction(
            label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset("images/logo1.png"),
            ),
            const Text(
              "Welcome Driver",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "jdcruz@gmail.com",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white38,
                    fontSize: 15,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white38,
                    fontSize: 15,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
              child: const Text(
                "Don't have an Account? Sign Up here",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => SignUpScreen()));
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                validateForm(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[400],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
