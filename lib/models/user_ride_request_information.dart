import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation {
  LatLng? originLatLng;
  String? originAddress;
  LatLng? destinationLatLng;
  String? destinationAddress;
  String? userName;
  String? userPhone;

  UserRideRequestInformation({
    this.originLatLng,
    this.originAddress,
    this.destinationAddress,
    this.destinationLatLng,
    this.userName,
    this.userPhone,
  });
}
