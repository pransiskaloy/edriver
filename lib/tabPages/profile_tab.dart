import 'package:edriver/global/global.dart';
import 'package:edriver/infoHandler/app_info.dart';
import 'package:edriver/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  String ratingsNumber = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRatings();
  }

  getRatings() {
    setState(() {
      ratingsNumber = Provider.of<AppInfo>(context, listen: false).driverAverageRatings.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white54,
              Colors.white70,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              onlineDriverData.name!,
              style: GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Color(0xFF414141))),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 9.0,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.brown.shade800,
                child: const Text('AH'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              onlineDriverData.email!.toLowerCase(),
              style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 20, color: Color(0xFF414141))),
            ),
            const SizedBox(height: 10),
            Text(
              onlineDriverData.phone!,
              style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 20, color: Color(0xFF414141))),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length.toString(),
                        style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 25, color: Color(0xFF414141), fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        "Trips",
                        style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 17, color: Color.fromARGB(255, 135, 134, 134), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "P" + Provider.of<AppInfo>(context, listen: false).driverTotalEarnings,
                        style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 25, color: Color(0xFF414141), fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        "Earnings",
                        style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 17, color: Color.fromARGB(255, 135, 134, 134), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            ratingsNumber,
                            style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 25, color: Color(0xFF414141), fontWeight: FontWeight.bold)),
                          ),
                          const Icon(Icons.star_rate_rounded, color: Color(0xFF414141))
                        ],
                      ),
                      Text(
                        "Ratings",
                        style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 17, color: Color.fromARGB(255, 135, 134, 134), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // FirebaseDatabase.instance.ref().child("test").set("hello");
                fAuth.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
    // return Center(
    //   child: ElevatedButton(
    //     onPressed: () async {
    //       // FirebaseDatabase.instance.ref().child("test").set("hello");
    //       fAuth.signOut();
    //       Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
    //     },
    //     child: const Text("Logout"),
    //   ),
    // );
  }
}
