import 'dart:async';

import 'package:edriver/assistants/assistant_methods.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/main.dart';
import 'package:edriver/pushNotificatons/push_notification_system.dart';
import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:edriver/widgets/confirm_status.dart';
import 'package:edriver/widgets/global.dart';
import 'package:edriver/widgets/third_button.dart';
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
  bool isStatus = false;
  String titlestatus = 'TURN ONLINE';
  String status = '';
  Color colorstatus = Colors.greenAccent.shade400;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
    // AssistantMethods.readCurrentDriverInformation(context);
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.generateAndGetToken();
    pushNotificationSystem.initializeCloudMessaging(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: initialPosition,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            //blue-themed google map
            // blueThemeGoogleMap(newGoogleMapController);

            locateDriverPosition();
          },
        ),

        Positioned(
          top: 50,
          left: 20,
          child: GestureDetector(
            onTap: () {
              if (isStatus == true) {
                goOfline();
                setState(() {
                  colorstatus = Colors.greenAccent.shade400;
                  titlestatus = 'TURN ONLINE';
                  isStatus = false;
                });
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MySplashScreen()));
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MySplashScreen()));
              }
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: 0.5, offset: Offset(0.7, 0.7))]),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black45,
                ),
              ),
            ),
          ),
        ),

        //Offline and Online Button
        Positioned(
          left: 0,
          right: 0,
          bottom: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton3(
                color: colorstatus,
                title: titlestatus,
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => ConfirmStatus(
                            title: (!isStatus) ? 'TURN ONLINE' : 'Are You Sure?',
                            subtitle: (!isStatus) ? 'You are about to go Online' : 'You are about to go Offline',
                            buttonColor: (!isStatus) ? Colors.greenAccent.shade400 : Colors.redAccent.shade400,
                            onPressed: () async {
                              if (!isStatus) {
                                goOnline();
                                locateDriverPosition();
                                Navigator.of(context).pop();
                                setState(() {
                                  colorstatus = Colors.redAccent.shade400;
                                  titlestatus = 'TURN OFFLINE';
                                  isStatus = true;
                                });
                              } else {
                                goOfline();
                                Navigator.of(context).pop();
                                setState(() {
                                  colorstatus = Colors.greenAccent.shade400;
                                  titlestatus = 'TURN ONLINE';
                                  isStatus = false;
                                });
                              }
                            },
                          ));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  void locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(driverCurrentPosition!, context);

    // AssistantMethods.readDriverRatings(context);
    // AssistantMethods.readDriverEarnings(context);
    // AssistantMethods.readTripKeysForOnlineDriver(context);
  }

  void goOnline() async {
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

  void updateDriversLocationAtRealTime() {
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

  void goOfline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus");
    DatabaseReference? ref2 = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideRequest");

    ref.onDisconnect();
    ref.remove();
    ref = null;
    ref2.onDisconnect();
    ref2.remove();
    ref2 = null;
  }
}
