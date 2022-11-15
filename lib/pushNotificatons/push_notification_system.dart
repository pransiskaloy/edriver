import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/models/user_ride_request_information.dart';
import 'package:edriver/pushNotificatons/notification_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    //1 Terminated - when the app is completely closed and open directly from push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        readUserRideRequestInformation(remoteMessage.data['rideRequestId'], context);
        //display ride request information - user information who request the ride
      }
    });

    //2 Foreground - when app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readUserRideRequestInformation(remoteMessage!.data['rideRequestId'], context);
      //display ride request information - user information who request the ride
    });

    //3 Background - when the app is in the background and open from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readUserRideRequestInformation(remoteMessage!.data['rideRequestId'], context);
      //display ride request information - user information who request the ride
    });
  }

  readUserRideRequestInformation(String userRideRequestId, BuildContext context) {
    FirebaseDatabase.instance.ref().child("All Ride Request").child(userRideRequestId).once().then((snapData) {
      if (snapData.snapshot.value != null) {
        audioPlayer.open(Audio("music/music_notification.mp3"));
        audioPlayer.play();

        double originLat = double.parse((snapData.snapshot.value as Map)["origin"]['latitude']);
        double originLng = double.parse((snapData.snapshot.value as Map)["origin"]['longitude']);
        String originAddress = (snapData.snapshot.value as Map)["originAddress"];

        double destinationLat = double.parse((snapData.snapshot.value as Map)["destination"]['latitude']);
        double destinationLng = double.parse((snapData.snapshot.value as Map)["destination"]['longitude']);
        String destinationAddress = (snapData.snapshot.value as Map)["destinationAddress"];

        String userName = (snapData.snapshot.value as Map)["userName"];
        String userPhone = (snapData.snapshot.value as Map)["userPhone"];
        String petQuantity = (snapData.snapshot.value as Map)["petQuantity"];
        String petDescription = (snapData.snapshot.value as Map)["petDescription"];
        String rideRequestId = userRideRequestId;

        UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();
        userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
        userRideRequestDetails.originAddress = originAddress;
        userRideRequestDetails.destinationAddress = destinationAddress;
        userRideRequestDetails.destinationLatLng = LatLng(destinationLat, destinationLng);

        userRideRequestDetails.userName = userName;
        userRideRequestDetails.userPhone = userPhone;
        userRideRequestDetails.rideRequestId = rideRequestId;
        userRideRequestDetails.petDescription = petDescription;
        userRideRequestDetails.petQuantity = petQuantity;

        showDialog(
          context: context,
          builder: (BuildContext context) => NotificationDialogBox(
            userRideRequestDetails: userRideRequestDetails,
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "The Ride Request does not exist anymore!");
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();

    FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("token").set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}
