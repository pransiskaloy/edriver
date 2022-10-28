import 'dart:async';
import 'package:edriver/assistants/assistant_methods.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/main.dart';
import 'package:edriver/models/user_ride_request_information.dart';
import 'package:edriver/widgets/canceled_trip.dart';
import 'package:edriver/widgets/fare_amount_collection_dialog.dart';
import 'package:edriver/widgets/global.dart';
import 'package:edriver/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewTripScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;
  NewTripScreen({this.userRideRequestDetails});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  String? buttonTitle = "Arrived";
  Color? buttonColor = Colors.green;

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircles = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polylinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPadding = 0;
  StreamSubscription<DatabaseEvent>? tripSubscription;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;
  String? rideRequestStatus = "accepted";
  String durationFromOriginToDestination = "";
  bool isRequestDirectionDetails = false;
  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );
    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    Navigator.pop(context);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList =
        polylinePoints.decodePolyline(directionDetailsInfo!.e_points!);
    polylinePositionCoordinates.clear();
    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        polylinePositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    setOfPolyline.clear();
    setState(() {
      Polyline polyline = Polyline(
        width: 5,
        color: const Color.fromARGB(255, 219, 63, 52),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      setOfPolyline.add(polyline);
    });
    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    newTripGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });
    Circle originCircle = Circle(
        circleId: const CircleId("originID"),
        fillColor: Colors.blue,
        radius: 12,
        strokeWidth: 2,
        strokeColor: Colors.white,
        center: originLatLng);

    Circle destinationCircle = Circle(
        circleId: const CircleId("destinationID"),
        fillColor: Colors.green,
        radius: 12,
        strokeWidth: 2,
        strokeColor: Colors.white,
        center: destinationLatLng);

    setState(() {
      setOfCircles.add(originCircle);
      setOfCircles.add(destinationCircle);
    });
  }

  @override
  void initState() {
    super.initState();
    saveAssignedDriverDetailToUserRideRequest();
  }

  createDriverIconMarker() {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png")
          .then((value) {
        iconAnimatedMarker = value;
      });
    }
  }

  //animating the driver current position until it reached to the users preferred destination
  getDriversLocationUpdatesAtRealTime() {
    LatLng oldLatLng = LatLng(0, 0);
    streamSubscriptionDriverLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;

      LatLng latLngDriverPosition = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      );

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLngDriverPosition,
        icon: iconAnimatedMarker!,
        infoWindow: const InfoWindow(title: "This is your position."),
      );

      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: latLngDriverPosition, zoom: 16);
        newTripGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        setOfMarkers
            .remove((element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });

      oldLatLng = latLngDriverPosition;
      updateDurationTimeAtRealTime();

      //update driver location in realtime in firebase database
      Map driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude,
        "longitude": onlineDriverCurrentPosition!.longitude,
      };

      FirebaseDatabase.instance
          .ref()
          .child("All Ride Request")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("driverLocation")
          .set(driverLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime() async {
    if (isRequestDirectionDetails == false) {
      isRequestDirectionDetails = true;

      if (onlineDriverCurrentPosition == null) {
        return;
      }
      var destinationLatLng;
      var originLatLng = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      ); //driver current location
      if (rideRequestStatus == "accepted") {
        //if the driver accepted the request
        destinationLatLng =
            widget.userRideRequestDetails!.originLatLng; //user pick up location
      } else {
        //if the driver arrived to user origin location
        destinationLatLng = widget.userRideRequestDetails!
            .destinationLatLng; // user drop-off location
      }

      var directionInformation =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
              originLatLng, destinationLatLng);

      if (directionInformation != null) {
        setState(() {
          durationFromOriginToDestination = directionInformation.duration_text!;
        });
      }

      isRequestDirectionDetails = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    createDriverIconMarker();
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: mapPadding),
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: initialPosition,
          markers: setOfMarkers,
          circles: setOfCircles,
          polylines: setOfPolyline,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newTripGoogleMapController = controller;

            //blue-themed google map
            // blueThemeGoogleMap(newGoogleMapController);
            setState(() {
              mapPadding = 370;
            });
            var driverCurrentLatLng = LatLng(
              driverCurrentPosition!.latitude,
              driverCurrentPosition!.longitude,
            );

            var userCurrentLatLng = widget.userRideRequestDetails!.originLatLng;
            drawPolyLineFromOriginToDestination(
                driverCurrentLatLng, userCurrentLatLng!);
            getDriversLocationUpdatesAtRealTime();
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 18,
                    spreadRadius: .5,
                    offset: Offset(.6, .6),
                  )
                ]),
            child: Column(
              children: [
                const SizedBox(
                  height: 18,
                ),
                Text(
                  "ETA " + durationFromOriginToDestination,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F6CAD),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                const Divider(
                  height: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                //user information
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.phone_android,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.userRideRequestDetails?.userName
                              .toString()
                              .toUpperCase() ??
                          "",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F6CAD),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                //user Pickup location with icon
                Row(
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
                const SizedBox(
                  height: 20,
                ),
                //user Drop-off location with icon
                Row(
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

                const SizedBox(
                  height: 18,
                ),
                const Divider(
                  height: 2,
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    //driver has arrived at user Pickup Location - Arrived button
                    if (rideRequestStatus == "accepted") {
                      rideRequestStatus = "arrived";
                      FirebaseDatabase.instance
                          .ref()
                          .child("All Ride Request")
                          .child(widget.userRideRequestDetails!.rideRequestId!)
                          .child("status")
                          .set(rideRequestStatus);

                      setState(() {
                        buttonTitle = "Start Trip";
                        buttonColor = Colors.blue;
                      });

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext c) => ProgressDialog(
                                message: "Loading...",
                              ));
                      await drawPolyLineFromOriginToDestination(
                        widget.userRideRequestDetails!.originLatLng!,
                        widget.userRideRequestDetails!.destinationLatLng!,
                      );
                      Navigator.pop(context);
                    }
                    //driver has started the trip - picked up the user - Start Trip Button
                    else if (rideRequestStatus == "arrived") {
                      rideRequestStatus = "ontrip";
                      FirebaseDatabase.instance
                          .ref()
                          .child("All Ride Request")
                          .child(widget.userRideRequestDetails!.rideRequestId!)
                          .child("status")
                          .set(rideRequestStatus);

                      setState(() {
                        buttonTitle = "End Trip";
                        buttonColor = Colors.red;
                      });
                    }
                    //if user has reached to the destination/ drop-off location - End Trip
                    else if (rideRequestStatus == "ontrip") {
                      endTripNow();
                    }
                  },
                  icon: const Icon(
                    Icons.directions_car,
                    color: Colors.white70,
                    size: 25,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    primary: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // <-- Radius
                    ),
                  ),
                  label: Text(
                    buttonTitle!.toUpperCase(),
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  endTripNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) => ProgressDialog(
        message: "Please wait ...",
      ),
    );

    //get the tripDirectionDetails - distance traveled
    var currentDriverPositionLatLng = LatLng(
      onlineDriverCurrentPosition!.latitude,
      onlineDriverCurrentPosition!.longitude,
    );

    var tripDirectionDetails =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            currentDriverPositionLatLng,
            widget.userRideRequestDetails!.originLatLng!);

    //calculate fare amount
    double totalFareAmount =
        AssistantMethods.calculateFareAmountFromOriginToDestination(
            tripDirectionDetails!);

    Map endTrip = {
      "fare_amount": totalFareAmount,
      "end_trip_time": DateTime.now().toString()
    };
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child('end_trip')
        .set(endTrip);
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child("status")
        .set("ended");
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideRequest")
        .set("idle");
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus")
        .set("idle");
    streamSubscriptionDriverLivePosition!.cancel();

    Navigator.pop(context);

    //display fare amount in dialog box
    showDialog(
      context: context,
      builder: (BuildContext c) => FareAmountCollectionDialog(
        totalFareAmount: totalFareAmount,
      ),
    );

    //save fare amount in dialog box
    saveFareAmountDriverEarnings(totalFareAmount);
  }

  saveFareAmountDriverEarnings(double totalFareAmount) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        //if the driver have existing earnings
        double oldEarning = double.parse(snap.snapshot.value.toString());
        double driverTotalEarnings = oldEarning + totalFareAmount;
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("earnings")
            .set(driverTotalEarnings.toString());
      } else {
        //if driver has first time earning
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("earnings")
            .set(totalFareAmount.toString());
      }
    });
  }

  void saveAssignedDriverDetailToUserRideRequest() {
    tripRef = FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!);
    Map driverLocationDataMap = {
      "latitude": driverCurrentPosition!.latitude,
      "longitude": driverCurrentPosition!.longitude,
    };
    tripRef!.child("driverLocation").set(driverLocationDataMap);
    tripRef!.child("status").set("accepted");
    tripRef!.child("driverId").set(onlineDriverData.id);
    tripRef!.child("driverName").set(onlineDriverData.name);
    tripRef!.child("driverPhone").set(onlineDriverData.phone);
    tripRef!.child("car_details").set(onlineDriverData.car_color.toString() +
        " " +
        onlineDriverData.car_model.toString() +
        " " +
        onlineDriverData.car_number.toString());

    saveRideRequestIdToDriverHistory();
    //Check if User will cancel the trip request
    tripSubscription = tripRef!.onValue.listen((event) async {
      //Checking if event is null
      if (event.snapshot.value == null) {
        return;
      }
      if ((event.snapshot.value as Map)['status'] != null) {
        setState(() {
          tripStatus = (event.snapshot.value as Map)['status'];
        });

        if (tripStatus == 'Canceled') {
          streamSubscriptionDriverLivePosition!.cancel();
          streamSubscriptionDriverLivePosition = null;

          var response = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => TripCanceled());
          if (response == 'tripCanceled') {
            tripRef!.onDisconnect();
            tripRef = null;
            tripSubscription!.cancel();
            tripSubscription = null;
            MyApp.restartApp(context);
          }
        }
      }
    });
  }

  void saveRideRequestIdToDriverHistory() {
    DatabaseReference tripsHistoryRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("trip_history");

    tripsHistoryRef
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .set(true);
  }
}
