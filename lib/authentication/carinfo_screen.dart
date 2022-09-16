import 'package:edriver/global/global.dart';
import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
    };

    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);
    showToaster(context, "Car details has been saved.", "success");

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
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset("images/logo1.png"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Car Information",
                style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: carModelTextEditingController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Car Model",
                    hintText: "Toyota Innova",
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
                  controller: carNumberTextEditingController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Plate Number",
                    hintText: "AAH 123",
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
                  controller: carColorTextEditingController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Color",
                    hintText: "Matte Black",
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
                child: DropdownButtonFormField(
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.white70,
                    size: 30,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.white),
                    ),
                  ),
                  isExpanded: true,
                  dropdownColor: Colors.blue[300],
                  hint: const Text(
                    "Car Type",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white70,
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
                          color: Colors.white,
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
                  primary: Colors.blue[400],
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
