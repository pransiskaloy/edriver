import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:edriver/widgets/TaxiOutlineButton.dart';
import 'package:flutter/material.dart';

class TripDecline extends StatelessWidget {
  final String title;
  final String description;
  final String respo;

  TripDecline(
      {required this.title, required this.description, required this.respo});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25.0,
                      fontFamily: 'Muli',
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 200,
                  child: TaxiOutlineButton(
                    title: 'Close',
                    color: Colors.grey.shade400,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => MySplashScreen()));
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
