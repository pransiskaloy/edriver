import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:edriver/assistants/assistant_methods.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/mainScreens/new_trip_screen.dart';
import 'package:edriver/models/user_ride_request_information.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationDialogBox extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 1,
      child: Container(
        // margin: const EdgeInsets.only(top: 8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              "New Ride Request",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Color(0xFF4F6CAD),
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: [
                //origin address with icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 45,
                        height: 45,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails?.originAddress ?? "",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF4F6CAD),
                              fontWeight: FontWeight.w200,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                //destination location with icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails?.destinationAddress ?? "",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF4F6CAD),
                              fontWeight: FontWeight.w200,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          audioPlayer.pause();
                          audioPlayer.stop();
                          audioPlayer = AssetsAudioPlayer();

                          FirebaseDatabase.instance.ref().child("All Ride Request").child(widget.userRideRequestDetails!.rideRequestId!).remove().then((snap) {
                            FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus").set("idle");
                            FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideRequest").set("idle");
                          }).then((value) {
                            FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("trip_history").child(widget.userRideRequestDetails!.rideRequestId!).remove();
                          }).then((value) {
                            Fluttertoast.showToast(msg: "Ride request has been canceled!");
                          });
                          SystemNavigator.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          side: const BorderSide(width: 1, color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50), // <-- Radius
                          ),
                        ),
                        child: Text(
                          "CANCEL",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          audioPlayer.pause();
                          audioPlayer.stop();
                          audioPlayer = AssetsAudioPlayer();

                          //accept the ride request
                          acceptRideRequest(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50), // <-- Radius
                          ),
                        ),
                        child: Text(
                          "ACCEPT",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    String getRideRequestId = "";
    FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus").once().then((snap) {
      if (snap.snapshot.value != null) {
        getRideRequestId = snap.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: "Ride Request was canceled!");
      }

      if (getRideRequestId == widget.userRideRequestDetails!.rideRequestId) {
        FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideRequest").set("accepted");
        AssistantMethods.pauseLiveLocationUpdates();
        //proceed to trip screen when the driver accepts the ride request
        Navigator.push(context, MaterialPageRoute(builder: (c) => NewTripScreen(userRideRequestDetails: widget.userRideRequestDetails)));
      } else {
        Fluttertoast.showToast(msg: "Ride Request was canceled!");
      }
    });
  }
}
