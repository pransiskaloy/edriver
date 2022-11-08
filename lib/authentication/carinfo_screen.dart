import 'package:edriver/global/global.dart';
import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({Key? key}) : super(key: key);

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ["Furfetch-x", "Furfetch-go", "Motorcycle"];
  String? selectedCarType;

  saveCareInfo() {
    Map driverCarInfoMap = {
      "car_model": carModelTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_color": carColorTextEditingController.text.trim(),
      "car_type": selectedCarType,
      "date_created": DateTime.now().toString(),
      "status": "forApproval",
    };
    DatabaseReference imageRef = FirebaseDatabase.instance.ref().child("drivers/${currentFirebaseUser!.uid}/ImagesUploaded");
    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    imageRef.set('done');
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);
    showToaster(context, "Car details has been saved.", "success");
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("images/carinformation.png"),
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: carModelTextEditingController,
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
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: carNumberTextEditingController,
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
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: carColorTextEditingController,
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
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15.0),
              child: DropdownButtonFormField(
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Color(0xFF4F6CAD),
                  size: 30,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.category_rounded,
                      color: Color(0xFF4F6CAD),
                      size: 20,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                  ),
                ),
                isExpanded: true,
                dropdownColor: Colors.blue[300],
                hint: const Text(
                  "Car Type",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF4F6CAD),
                  ),
                ),
                value: selectedCarType,
                onChanged: (newValue) {
                  setState(() {
                    selectedCarType = newValue.toString();
                  });
                },
                items: carTypesList.map((car) {
                  return DropdownMenuItem(
                    child: Text(
                      car,
                      style: const TextStyle(
                        color: Color(0xFF4F6CAD),
                      ),
                    ),
                    value: car,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                if (carColorTextEditingController.text.isNotEmpty && carModelTextEditingController.text.isNotEmpty && carNumberTextEditingController.text.isNotEmpty && selectedCarType != null) {
                  saveCareInfo();
                }
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
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 7.0),
                child: Text(
                  "Sign Up",
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
        ),
      ),
    );
  }
}
