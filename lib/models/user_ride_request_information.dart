import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation {
  LatLng? originLatLng;
  String? originAddress;
  LatLng? destinationLatLng;
  String? destinationAddress;
  String? userName;
  String? userPhone;
  String? rideRequestId;
  String? petQuantity;
  String? petDescription;

  UserRideRequestInformation({
    this.originLatLng,
    this.originAddress,
    this.destinationAddress,
    this.destinationLatLng,
    this.userName,
    this.userPhone,
    this.rideRequestId,
    this.petQuantity,
    this.petDescription,
  });
}
