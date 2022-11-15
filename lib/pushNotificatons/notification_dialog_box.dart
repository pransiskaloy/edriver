import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:edriver/assistants/assistant_methods.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/main.dart';
import 'package:edriver/mainScreens/new_trip_screen.dart';
import 'package:edriver/models/user_ride_request_information.dart';
import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:edriver/widgets/progressDialog.dart';
import 'package:edriver/widgets/trip_declined.dart';
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
  void initState() {
    super.initState();
    AssistantMethods.pauseLiveLocationUpdates();
  }

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
                  height: 30,
                ),
                //pet quantity with icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/quantity.png",
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails?.petQuantity ?? "",
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
                //pet quantity with icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/notes.png",
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails?.petDescription ?? "",
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

                          DatabaseReference declineTrip = FirebaseDatabase.instance.ref().child('drivers/${currentFirebaseUser!.uid}/newRideRequest');
                          declineTrip.set('canceled');
                          AssistantMethods.pauseLiveLocationUpdates();
                          MyApp.restartApp(context);
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

  void acceptRideRequest(BuildContext context) {
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => ProgressDialog(status: 'Accepting Trip...'));
    String getRideRequestId = "";
    String uid = currentFirebaseUser!.uid;
    DatabaseReference newTripref = FirebaseDatabase.instance.ref('drivers/$uid/newRideRequest');

    newTripref.once().then((snap) async {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      String thisTripID = '';
      if (snap.snapshot.value != null) {
        thisTripID = snap.snapshot.value.toString();
      } else {
        audioPlayer.pause();
        audioPlayer.stop();
        audioPlayer = AssetsAudioPlayer();
        var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripDecline(
                  title: 'Trip Notification',
                  description: 'Trip ID not found',
                  respo: 'notfound',
                ));
        if (response == 'notfound') {
          newTripref.set('idle');
          AssistantMethods.resumeLiveLocationUpdates();
        }
      }

      //CHECKING TRIP STATUS----------------->
      //if Trip has been accepted
      if (thisTripID == widget.userRideRequestDetails!.rideRequestId) {
        audioPlayer.pause();
        audioPlayer.stop();
        audioPlayer = AssetsAudioPlayer();
        newTripref.set('accepted');
        print("Trip Accepted");
        AssistantMethods.pauseLiveLocationUpdates();
        Navigator.push(context, MaterialPageRoute(builder: (c) => NewTripScreen(userRideRequestDetails: widget.userRideRequestDetails)));
        //if trip has been cancled
      } else if (thisTripID == 'Canceled') {
        audioPlayer.pause();
        audioPlayer.stop();
        audioPlayer = AssetsAudioPlayer();
        var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripDecline(
                  title: 'Trip Notification',
                  description: 'Trip Request has been canceled',
                  respo: 'canceledout',
                ));
        if (response == 'canceledout') {
          newTripref.set('waiting');
          AssistantMethods.resumeLiveLocationUpdates();
        }
        // if trip has timed out
      } else if (thisTripID == 'timeout') {
        audioPlayer.pause();
        audioPlayer.stop();
        audioPlayer = AssetsAudioPlayer();
        var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripDecline(
                  title: 'Trip Notification',
                  description: 'Trip Request timed out',
                  respo: 'timedout',
                ));
        if (response == 'timedout') {
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
        }
        // if trip not found
      } else {
        audioPlayer.pause();
        audioPlayer.stop();
        audioPlayer = AssetsAudioPlayer();
        var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripDecline(
                  title: 'Trip Notification',
                  description: 'Trip ID not found',
                  respo: 'notfound',
                ));
        if (response == 'notfound') {
          newTripref.set('waiting');
          AssistantMethods.resumeLiveLocationUpdates();
        }
      }
    });
  }
}
