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
  String? imageUrlCar;
  String ratingsNumber = "";
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController colorTextEditingController = TextEditingController();
  TextEditingController numberTextEditingController = TextEditingController();
  TextEditingController modelTextEditingController = TextEditingController();
  TextEditingController typeTextEditingController = TextEditingController();
  bool _passwordVisible = false;
  bool _readOnly = true;

  validateForm(BuildContext context) {
    if (phoneTextEditingController.text.length < 11 || phoneTextEditingController.text.length > 11) {
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
    getCarImage();
    setController();
  }

  setController() {
    setState(() {
      nameTextEditingController = TextEditingController(text: onlineDriverData.name);
      phoneTextEditingController = TextEditingController(text: onlineDriverData.phone);
      emailTextEditingController = TextEditingController(text: onlineDriverData.email);
      colorTextEditingController = TextEditingController(text: onlineDriverData.car_color);
      numberTextEditingController = TextEditingController(text: onlineDriverData.car_number);
      modelTextEditingController = TextEditingController(text: onlineDriverData.car_model);
      typeTextEditingController = TextEditingController(text: onlineDriverData.car_type);
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

  getCarImage() async {
    final carRef = FirebaseStorage.instance.ref().child('carimage/' + currentFirebaseUser!.uid);
    // no need of the file extension, the name will do fine.
    var carUrl = await carRef.getDownloadURL();
    setState(() {
      imageUrlCar = carUrl;
    });
  }

  getRatings() {
    setState(() {
      var numb = double.parse(Provider.of<AppInfo>(context, listen: false).driverAverageRatings.toString()).toStringAsFixed(1);
      ratingsNumber = numb.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Personal Information',
              ),
              Tab(
                text: 'Car Information',
              ),
            ],
          ),
          backgroundColor: Colors.blue,
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
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
                                    "P " + double.parse(Provider.of<AppInfo>(context, listen: false).driverTotalEarnings).toStringAsFixed(2),
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
                      readOnly: true,
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
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _readOnly = !_readOnly;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF4F6CAD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50), // <-- Radius
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * .4,
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "Edit Phone",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 20,
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
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  (imageUrlCar != null)
                      ? Center(
                          child: SizedBox(
                            height: 200,
                            width: 300,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                imageUrlCar!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 300,
                                child: Image.asset(
                                  "images/carImage1.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  //CAR MODEL
                  Container(
                    width: MediaQuery.of(context).size.width * .93,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      readOnly: true,
                      controller: modelTextEditingController,
                      decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.directions_car_filled,
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
                          hintText: "Toyota Innova",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 172, 170, 170),
                            letterSpacing: 1.5,
                          ),
                          labelText: "Car Model",
                          labelStyle: const TextStyle(
                            color: Color(0xFF4F6CAD),
                            fontSize: 18,
                          ),
                          fillColor: Colors.white70),
                    ),
                  ),
                  //CAR NUMBER
                  Container(
                    width: MediaQuery.of(context).size.width * .93,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: TextField(
                      readOnly: true,
                      controller: numberTextEditingController,
                      decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.pin,
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
                          hintText: "AAH 123",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 172, 170, 170),
                            letterSpacing: 1.5,
                          ),
                          labelText: "Plate Number",
                          labelStyle: const TextStyle(
                            color: Color(0xFF4F6CAD),
                            fontSize: 18,
                          ),
                          fillColor: Colors.white70),
                    ),
                  ),
                  //CAR COLOR
                  Container(
                    width: MediaQuery.of(context).size.width * .93,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: colorTextEditingController,
                      decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.palette,
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
                          hintText: "Matte Black",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 172, 170, 170),
                            letterSpacing: 1.5,
                          ),
                          labelText: "Color",
                          labelStyle: const TextStyle(
                            color: Color(0xFF4F6CAD),
                            fontSize: 18,
                          ),
                          fillColor: Colors.white70),
                    ),
                  ),

                  //CAR TYPE
                  Container(
                    width: MediaQuery.of(context).size.width * .93,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: TextField(
                      controller: typeTextEditingController,
                      decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.category_rounded,
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
                          hintText: "Matte Black",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 172, 170, 170),
                            letterSpacing: 1.5,
                          ),
                          labelText: "Color",
                          labelStyle: const TextStyle(
                            color: Color(0xFF4F6CAD),
                            fontSize: 18,
                          ),
                          fillColor: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
