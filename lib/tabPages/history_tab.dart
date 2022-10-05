import 'package:edriver/infoHandler/app_info.dart';
import 'package:edriver/widgets/history_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RatingsTabPage extends StatefulWidget {
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}

class _RatingsTabPageState extends State<RatingsTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 10),
            child: Text(
              "Trip History",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF4F6CAD)),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .90,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blueAccent,
                    Colors.blue,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 9.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "NUMBER OF TRIPS COMPLETED",
                    style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Text(
                    Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length.toString(),
                    style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "LIST OF HISTORY",
                style: GoogleFonts.poppins(letterSpacing: 2, textStyle: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return HistoryDisplay(
                  tripHistoryModel: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList[i],
                );
              },
              itemCount: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
