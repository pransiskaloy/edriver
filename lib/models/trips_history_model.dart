import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel {
  String? carDetails;
  String? destinationAddress;
  String? userName;
  String? userPhone;
  String? originAddress;
  String? endTime;
  String? fareAmount;
  String? status;
  String? petDescription;
  String? petQuantity;

  TripsHistoryModel({
    this.carDetails,
    this.destinationAddress,
    this.userName,
    this.userPhone,
    this.originAddress,
    this.endTime,
    this.fareAmount,
    this.status,
    this.petDescription,
    this.petQuantity,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot) {
    carDetails = (dataSnapshot.value as Map)["car_details"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    userName = (dataSnapshot.value as Map)["userName"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount =
        (dataSnapshot.value as Map)["end_trip"]["fare_amount"].toString();
    endTime = (dataSnapshot.value as Map)["end_trip"]["end_trip_time"];
    petDescription = (dataSnapshot.value as Map)["petDescription"];
    petQuantity = (dataSnapshot.value as Map)["petQuantity"];
  }
}
