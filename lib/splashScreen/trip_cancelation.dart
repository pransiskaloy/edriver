import 'package:edriver/authentication/images/uploadPhoto.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:edriver/widgets/TaxiOutlineButton%20copy.dart';
import 'package:edriver/widgets/trans_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TripCancelationDialog extends StatelessWidget {
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
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Account Verification',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Muli',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Your have not registered your Account completely.\n Do you wish to continue?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UploadSelfPhoto()));
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
                        "Proceed",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  child: TransparentButton(
                    text: 'Log out',
                    color: Colors.transparent,
                    press: () async {
                      await fAuth.signOut();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MySplashScreen()));
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
