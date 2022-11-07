import 'package:edriver/models/directions.dart';
import 'package:edriver/models/trips_history_model.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  String driverTotalEarnings = "0";
  String driverAverageRatings = "0";
  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];

  void updatePickUpLocation(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocation(Directions userDropOffAddress) {
    userDropOffLocation = userDropOffAddress;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter) {
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripsKeyList) {
    historyTripsKeysList = tripsKeyList;
    historyTripsKeysList = tripsKeyList;
    notifyListeners();
  }

  updateOverAllHistoryInformation(TripsHistoryModel eachHistoryTrip) {
    allTripsHistoryInformationList.add(eachHistoryTrip);
    notifyListeners();
  }

  updateDriverEarnings(String driverEarnings) {
    driverTotalEarnings = driverEarnings;
  }

  updateDriverAverageRatings(String driverRatings) {
    driverAverageRatings = driverRatings;
  }
}
