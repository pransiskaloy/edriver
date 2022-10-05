import 'dart:async';

import 'package:edriver/assistants/assistant_methods.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/main.dart';
import 'package:edriver/pushNotificatons/push_notification_system.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.1907, 125.4553),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(driverCurrentPosition!, context);

    AssistantMethods.readDriverRatings(context);
    AssistantMethods.readDriverEarnings(context);
    AssistantMethods.readTripKeysForOnlineDriver(context);
  }

  readCurrentDriverInformation() async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid);
    databaseReference.onValue.listen((snap) {
      if (snap.snapshot.value != null) {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.car_color = (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_model = (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number = (snap.snapshot.value as Map)["car_details"]["car_number"];
        onlineDriverData.car_type = (snap.snapshot.value as Map)["car_details"]["car_type"];

        driverVehicleType = onlineDriverData.car_type;
      }
    });
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            //blue-themed google map
            // blueThemeGoogleMap(newGoogleMapController);

            locateDriverPosition();
          },
        ),

        //ui for online-offline driver
        statusText != "Turn Offline"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.9),
              )
            : Container(),

        Positioned(
          top: statusText != "Turn Offline" ? MediaQuery.of(context).size.height * 0.50 : 40,
          left: 0,
          right: 0,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                if (isDriverActive != true) {
                  driverIsOnlineNow();
                  updateDriversLocationAtRealTime();

                  setState(() {
                    statusText = "Turn Offline";
                    isDriverActive = true;
                    buttonColor = Colors.red;
                  });

                  //display toast
                  Fluttertoast.showToast(
                    msg: "You are online now!",
                    backgroundColor: Colors.green,
                  );
                } else {
                  driverIsOfflineNow();
                  setState(() {
                    statusText = "Turn Online";
                    isDriverActive = false;
                    buttonColor = Colors.red;
                  });

                  //display toast
                  Fluttertoast.showToast(
                    msg: "You are offline now!",
                    backgroundColor: Colors.red,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: statusText != "Turn Offline"
                  ? Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ]),
        ),
      ],
    );
  }

  driverIsOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    driverCurrentPosition = position;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
      currentFirebaseUser!.uid,
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus");
    DatabaseReference ref2 = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideRequest");

    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) {});
    ref2.set("idle"); //searching for ride request
    ref2.onValue.listen((event) {});
  }

  updateDriversLocationAtRealTime() {
    streamSubscriptionPosition = Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;

      if (isDriverActive == true) {
        Geofire.setLocation(
          currentFirebaseUser!.uid,
          driverCurrentPosition!.latitude,
          driverCurrentPosition!.longitude,
        );
      }

      LatLng latLng = LatLng(
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus");
    DatabaseReference? ref2 = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideRequest");

    ref.onDisconnect();
    ref.remove();
    ref = null;
    ref2.onDisconnect();
    ref2.remove();
    ref2 = null;

    Future.delayed(const Duration(milliseconds: 2000), () {
      // SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      MyApp.restartApp(context); //have minor error
    });
  }
}
