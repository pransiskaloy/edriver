import 'package:edriver/assistants/assistant_methods.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/main.dart';
import 'package:edriver/mainScreens/home_tab.dart';
import 'package:edriver/mainScreens/trip_history_screen.dart';
import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:edriver/splashScreen/trip_cancelation.dart';
import 'package:edriver/tabPages/earnings_tab.dart';
import 'package:edriver/tabPages/history_tab.dart';
import 'package:edriver/tabPages/profile_tab.dart';
import 'package:edriver/widgets/trip_declined.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    AssistantMethods.readCurrentDriverInformation(context);
    AssistantMethods.readDriverRatings(context);
    AssistantMethods.readDriverEarnings(context);
    AssistantMethods.readTripKeysForOnlineDriver(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "ehatid",
                  style: GoogleFonts.baloo2(
                    letterSpacing: -1,
                    textStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPetCategory(
                        category: 'Go Online',
                        color: Colors.white,
                        image: 'images/new_trip.png',
                        onTap: () {
                          DatabaseReference uploadImager = FirebaseDatabase.instance.ref('drivers/${currentFirebaseUser!.uid}/ImagesUploaded');

                          uploadImager.once().then((snap) async {
                            if (snap.snapshot.value != null) {
                              String status = snap.snapshot.value.toString();
                              if (status == 'notyet') {
                                var response = await showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => TripCancelationDialog());
                              } else {
                                DatabaseReference driverStatus = FirebaseDatabase.instance.ref('drivers/${currentFirebaseUser!.uid}/status');
                                driverStatus.once().then((snap) async {
                                  if (snap.snapshot.value != null) {
                                    String status = snap.snapshot.value.toString();
                                    print("Status=-========================================================");
                                    print(status);
                                    if (status == 'active') {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeTabPage()));
                                    } else if (status == 'forApproval') {
                                      var response = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) => TripDecline(
                                                title: 'Important Notification',
                                                description: 'Your Account is currently for approval',
                                                respo: 'forApproval',
                                              ));
                                      if (response == 'forApproval') {
                                        Navigator.of(context).pop();
                                      }
                                    } else if (status == 'Restricted') {
                                      var response = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) => TripDecline(
                                                title: 'Important Notification',
                                                description: 'Your Account is currently for Restricted',
                                                respo: 'restricted',
                                              ));
                                      if (response == 'restricted') {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  }
                                });
                              }
                            }
                          });
                        },
                      ),
                      buildPetCategory(
                        category: 'Trip History',
                        color: Colors.white,
                        image: 'images/history.png',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const RatingsTabPage()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Options",
                    style: TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPetCategory(
                        category: 'Profile',
                        color: Colors.white,
                        image: 'images/user.png',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProfileTabPage()));
                        },
                      ),
                      buildPetCategory(category: 'Support', color: Colors.white, image: 'images/customer-service.png', onTap: () {}),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPetCategory(
                        category: 'Log out',
                        color: Colors.white,
                        image: 'images/exit.png',
                        onTap: () async {
                          await fAuth.signOut();
                          MyApp.restartApp(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPetCategory({String? category, String? image, Color? color, onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color?.withOpacity(0.5),
                ),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      image!,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: 'Muli',
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
