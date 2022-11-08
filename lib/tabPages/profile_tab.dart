import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edriver/global/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edriver/infoHandler/app_info.dart';
import 'package:edriver/widgets/progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  String? imageUrl;
  String ratingsNumber = "";
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  bool _passwordVisible = false;
  bool _readOnly = true;

  validateForm(BuildContext context) {
    if (nameTextEditingController.text.length < 5) {
      showToaster(context, "Full Name must be at least 5 characters", 'fail');
    } else if (!emailTextEditingController.text.contains("@") || !emailTextEditingController.text.contains(".")) {
      showToaster(context, "Please enter a valid email", 'fail');
    } else if (phoneTextEditingController.text.length < 11 || phoneTextEditingController.text.length > 11) {
      showToaster(context, "Phone must have 11 digit number", 'fail');
    } else {
      saveDriverInfo();
    }
  }

  saveDriverInfo() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(
          message: "Processing . . .",
        );
      },
    );
    if (currentFirebaseUser != null) {
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(currentFirebaseUser!.uid).child('name').set(nameTextEditingController.text.trim());
      driversRef.child(currentFirebaseUser!.uid).child('phone').set(phoneTextEditingController.text.trim());
      driversRef.child(currentFirebaseUser!.uid).child('date_updated').set(DateTime.now().toString());

      Navigator.pop(context);
      Navigator.pop(context);
      showToaster(context, "Account has been updated.", "success");
      //
    } else {
      Navigator.pop(context);
      showToaster(context, "Account update failed.", "fail");
    }
  }

  void showToaster(BuildContext context, String str, String status) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          str,
          style: status == "success" ? const TextStyle(color: Colors.green, fontSize: 15) : const TextStyle(color: Colors.red, fontSize: 15),
        ),
        action: SnackBarAction(label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRatings();
    getImage();
    setController();
  }

  setController() {
    setState(() {
      nameTextEditingController = TextEditingController(text: onlineDriverData.name);
      phoneTextEditingController = TextEditingController(text: onlineDriverData.phone);
      emailTextEditingController = TextEditingController(text: onlineDriverData.email);
    });
  }

  getImage() async {
    final ref = FirebaseStorage.instance.ref().child('profileImage/' + currentFirebaseUser!.uid);
    // no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  getRatings() {
    setState(() {
      ratingsNumber = Provider.of<AppInfo>(context, listen: false).driverAverageRatings.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 9.0,
                        ),
                      ],
                    ),
                    child: (imageUrl != null
                        ? CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(imageUrl!),
                          )
                        : CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.brown.shade800,
                            child: const Text('AH'),
                          )),
                  ),
                  const SizedBox(height: 10),
                  // Text(
                  //   onlineDriverData.name!,
                  //   style: GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xFF414141))),
                  // ),
                  // const SizedBox(height: 10),
                  // Text(
                  //   onlineDriverData.email!.toLowerCase(),
                  //   style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 20, color: Color(0xFF414141))),
                  // ),
                  // const SizedBox(height: 10),
                  // Text(
                  //   onlineDriverData.phone!,
                  //   style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 20, color: Color(0xFF414141))),
                  // ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Trips",
                              style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 17, color: Color.fromARGB(255, 135, 134, 134), fontWeight: FontWeight.bold)),
                            ),
                            Text(
                              Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length.toString(),
                              style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 25, color: Color(0xFF414141), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Earnings",
                              style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 17, color: Color.fromARGB(255, 135, 134, 134), fontWeight: FontWeight.bold)),
                            ),
                            Text(
                              "P " + Provider.of<AppInfo>(context, listen: false).driverTotalEarnings,
                              style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 25, color: Color(0xFF414141), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Ratings",
                              style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 17, color: Color.fromARGB(255, 135, 134, 134), fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              children: [
                                Text(
                                  ratingsNumber,
                                  style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 25, color: Color(0xFF414141), fontWeight: FontWeight.bold)),
                                ),
                                const Icon(Icons.star_rate_rounded, color: Colors.orange)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //FULLNAME
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                readOnly: _readOnly,
                controller: nameTextEditingController,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.person_rounded,
                        color: Color(0xFF4F6CAD),
                        size: 20,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    filled: true,
                    hintText: "Full Name...",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Full Name",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            //EMAIL
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: TextField(
                readOnly: true,
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.mail_rounded,
                        color: Color(0xFF4F6CAD),
                        size: 20,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    filled: true,
                    hintText: "Email...",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Email",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            //PHONE
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                readOnly: _readOnly,
                keyboardType: TextInputType.phone,
                controller: phoneTextEditingController,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.phone_rounded,
                        color: Color(0xFF4F6CAD),
                        size: 20,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    filled: true,
                    hintText: "09x-xxxx-xxx",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Phone",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 25),
              child: (_readOnly
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * .50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF4F6CAD)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            primary: const Color(0xFF4F6CAD),
                            onSurface: const Color(0xFF4F6CAD)),
                        onPressed: () {
                          setState(() {
                            _readOnly = !_readOnly;
                          });
                        },
                        child: SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              'Edit Profile',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 20,
                                  color: Color(0xFF4F6CAD),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                primary: Colors.red,
                                onSurface: Colors.red),
                            onPressed: () {
                              setState(() {
                                _readOnly = !_readOnly;
                                setController();
                              });
                            },
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            validateForm(context);
                            // showToaster(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF4F6CAD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50), // <-- Radius
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * .33,
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Save",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
