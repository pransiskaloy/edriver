import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

DatabaseReference? tripRef;
String tripStatus = '';

final CameraPosition initialPosition = CameraPosition(
  target: LatLng(7.1907, 125.4553),
  zoom: 14.4746,
);
