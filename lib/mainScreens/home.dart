import 'package:edriver/global/global.dart';
import 'package:edriver/mainScreens/home_tab.dart';
import 'package:edriver/widgets/trip_declined.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Ehatid Driver",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    fontFamily: 'Muli'),
              ),
            ),
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
                  Icon(
                    Icons.more_horiz,
                    color: Colors.grey[800],
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
                        image: 'images/autonomous-car.png',
                        onTap: () {
                          DatabaseReference driverStatus =
                              FirebaseDatabase.instance.ref(
                                  'drivers/${currentFirebaseUser!.uid}/status');
                          driverStatus.once().then((snap) async {
                            if (snap.snapshot.value != null) {
                              String status = snap.snapshot.value.toString();
                              if (status == 'active') {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeTabPage()));
                              } else if (status == 'forApproval') {
                                var response = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        TripDecline(
                                          title: 'Important Notification',
                                          description:
                                              'Your Account is currently for approval',
                                          respo: 'forapproval',
                                        ));
                                if (response == 'forapproval') {
                                  Navigator.of(context).pop();
                                }
                              } else if (status == 'Restricted') {
                                var response = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        TripDecline(
                                          title: 'Important Notification',
                                          description:
                                              'Your Account is currently for Restricted',
                                          respo: 'restricted',
                                        ));
                                if (response == 'restricted') {
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          });
                        },
                      ),
                      buildPetCategory(
                        category: 'Earnings',
                        color: Colors.white,
                        image: 'images/earnings.png',
                        onTap: () {},
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
                  Icon(
                    Icons.more_horiz,
                    color: Colors.grey[800],
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
                        onTap: () {},
                      ),
                      buildPetCategory(
                        category: 'Trip Hsitory',
                        color: Colors.white,
                        image: 'images/history.png',
                        onTap: () {},
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPetCategory(
                          category: 'Support',
                          color: Colors.white,
                          image: 'images/customer-service.png',
                          onTap: () {}),
                      buildPetCategory(
                        category: 'Log out',
                        color: Colors.white,
                        image: 'images/exit.png',
                        onTap: () async {},
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

  Widget buildPetCategory(
      {String? category, String? image, Color? color, onTap}) {
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
