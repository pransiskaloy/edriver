import 'package:edriver/models/directions.dart';
import 'package:edriver/models/message.dart';
import 'package:edriver/models/trips_history_model.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  int countTotalChats = 0;
  String driverTotalEarnings = "0";
  String driverAverageRatings = "0";
  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];
  List<ChatMessage> allChatMessageList = [];
  List<String> chatKeysList = [];

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
    notifyListeners();
  }

  updateOverAllHistoryInformation(TripsHistoryModel eachHistoryTrip) {
    allTripsHistoryInformationList.add(eachHistoryTrip);
    notifyListeners();
  }

  updateOverAllChat(ChatMessage chatMessage) {
    allChatMessageList.add(chatMessage);
    notifyListeners();
  }

  updateDriverEarnings(String driverEarnings) {
    driverTotalEarnings = driverEarnings;
  }

  updateDriverAverageRatings(String driverRatings) {
    driverAverageRatings = driverRatings;
  }
}
