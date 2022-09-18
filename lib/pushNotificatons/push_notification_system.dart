import 'package:edriver/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging() async {
    //1 Terminated - when the app is completely closed and open directly from push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display ride request information - user information who request the ride
      }
    });

    //2 Foreground - when app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((event) {
      //display ride request information - user information who request the ride
    });

    //3 Background - when the app is in the background and open from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      //display ride request information - user information who request the ride
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token:***************************************");
    print(registrationToken);

    FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("token").set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}
