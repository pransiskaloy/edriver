import 'package:edriver/assistants/request_assistant.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/global/maps_key.dart';
import 'package:edriver/infoHandler/app_info.dart';
import 'package:edriver/models/direction_details_info.dart';
import 'package:edriver/models/directions.dart';
import 'package:edriver/models/trips_history_model.dart';
import 'package:edriver/models/user_model.dart';
import 'package:edriver/pushNotificatons/push_notification_system.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static void readCurrentDriverInformation(context) async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid);
    databaseReference.onValue.listen((snap) {
      if (snap.snapshot.value != null) {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.car_color =
            (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_model =
            (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number =
            (snap.snapshot.value as Map)["car_details"]["car_number"];
        onlineDriverData.car_type =
            (snap.snapshot.value as Map)["car_details"]["car_type"];

        driverVehicleType = onlineDriverData.car_type;
      }
    });
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }

  static Future<String> searchAddressForGeographicCoordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";
    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    if (requestResponse != "Error Occurred: No Response!") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude.toString();
      userPickUpAddress.locationLongitude = position.longitude.toString();
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocation(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static void readCurrentOnlineDriverInfo() async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);

        // print("name = " + userModelCurrentInfo!.name.toString());
      }
    });
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred: No Response!") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];
    directionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
    directionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdates() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static resumeLiveLocationUpdates() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
  }

  static double calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    //per km = in db
    //per minute = in db
    timeTraveledFarePerMinute = (directionDetailsInfo.duration_value! / 60) *
        perMin; //0.1 is dollar charge per minute

    distanceTraveledFarePerKilometer =
        (directionDetailsInfo.distance_value! / 1000) *
            perKm; //0.1 is dollar charge per minute

    double totalFare = distanceTraveledFarePerKilometer +
        timeTraveledFarePerMinute +
        basefare +
        bookingFee;

    return double.parse(totalFare.toStringAsFixed(2));
  }

  static void getBaseFare() {
    DatabaseReference getType = FirebaseDatabase.instance
        .ref()
        .child('drivers/${currentFirebaseUser!.uid}/car_details/car_type');
    getType.once().then((snap) {
      if (snap.snapshot.value != null) {
        String type = snap.snapshot.value.toString();
        DatabaseReference baseRef =
            FirebaseDatabase.instance.ref().child('BaseFare/$type');
        baseRef.once().then((snap) {
          if (snap.snapshot.value != null) {
            basefare = double.parse(snap.snapshot.value.toString());
            print("------------------------------->Bis Pir $basefare");
          }
        });
      }
    });
  }

  static void getValues() {
    DatabaseReference getKm =
        FirebaseDatabase.instance.ref().child('BaseFare/PerKm');
    DatabaseReference getMin =
        FirebaseDatabase.instance.ref().child('BaseFare/PerMin');
    DatabaseReference bookinF =
        FirebaseDatabase.instance.ref().child('BaseFare/BookingFee');
    getKm.once().then((snap) {
      if (snap.snapshot.value != null) {
        perKm = double.parse(snap.snapshot.value.toString());
        print(perKm);
      }
    });
    getMin.once().then((snap) {
      if (snap.snapshot.value != null) {
        perMin = double.parse(snap.snapshot.value.toString());
        print(perMin);
      }
    });
    bookinF.once().then((snap) {
      if (snap.snapshot.value != null) {
        bookingFee = double.parse(snap.snapshot.value.toString());
        print(bookingFee);
      }
    });
  }

  //retrieve the trip keys
  //trip keys - ride request uid
  static void readTripKeysForOnlineDriver(context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .orderByChild("driverId")
        .equalTo(fAuth.currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keyTripsId = snap.snapshot.value as Map;

        //count total number of trip and share it with Provider
        int overAllTripsCounter = keyTripsId.length;
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeyList = [];
        keyTripsId.forEach((key, value) {
          tripsKeyList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsKeys(tripsKeyList);

        //get trip keys data - trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context) {
    var tripsAllKeys =
        Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for (String eachKey in tripsAllKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Request")
          .child(eachKey)
          .orderByChild("time")
          .once()
          .then((snap) {
        var eachHistoryTrip = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if ((snap.snapshot.value as Map)["status"] == "ended") {
          //update OverAllTrips History Data
          Provider.of<AppInfo>(context, listen: false)
              .updateOverAllHistoryInformation(eachHistoryTrip);
        }
      });
    }
  }

  //read driver earnings
  static void readDriverEarnings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String driverEarnings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverEarnings(driverEarnings);
      }
    });
  }

  static void readDriverRatings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("ratings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String driverRatings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false)
            .updateDriverAverageRatings(driverRatings);
      }
    });
  }
}
