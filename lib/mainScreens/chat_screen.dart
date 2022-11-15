import 'package:edriver/assistants/assistant_methods.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/infoHandler/app_info.dart';
import 'package:edriver/models/message.dart';
import 'package:edriver/models/user_ride_request_information.dart';
import 'package:edriver/widgets/message_bubble.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;
  ChatScreen({this.userRideRequestDetails});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final fb = FirebaseDatabase.instance;
  DatabaseReference? referenceChatMessage;
  TextEditingController messageTextEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  saveChatMessage() {
    if (messageTextEditingController.text.toString() != "") {
      referenceChatMessage = FirebaseDatabase.instance.ref().child("All Ride Request").child(widget.userRideRequestDetails!.rideRequestId!).child("chats").push();
      Map chatMessageMap = {
        "senderId": fAuth.currentUser!.uid,
        "textMessage": messageTextEditingController.text.toString(),
        "time": DateTime.now().toString(),
      };
      setState(() {
        referenceChatMessage!.set(chatMessageMap).asStream();
        messageTextEditingController.clear();
        _scrollToBottom();
        // var controller = PrimaryScrollController.of(context);
        // controller!.animateTo(controller.position.minScrollExtent, duration: const Duration(seconds: 3), curve: Curves.ease);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToBottom());
    // var controller = PrimaryScrollController.of(context);
    var ref = fb.ref().child("All Ride Request").child(widget.userRideRequestDetails!.rideRequestId!).child("chats");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.userRideRequestDetails!.userName!,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_rounded)),
      ),
      body: Stack(
        children: [
          Positioned(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance.ref().child("All Ride Request").child(widget.userRideRequestDetails!.rideRequestId!).child("chats").orderByChild('time').onValue,
              builder: (context, snapshot) {
                List<ChatMessage> messageList = [];
                if (snapshot.hasData && snapshot.data != null && (snapshot.data! as DatabaseEvent).snapshot.value != null) {
                  final myMessages = Map<dynamic, dynamic>.from((snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
                  myMessages.forEach((key, value) {
                    final currentMessage = Map<String, dynamic>.from(value);
                    // currentMessage.entries.toList().sort(((a, b) => a.value['time'].toLowerCase().toString().compareTo(b.value['time'].toLowerCase().toString())));
                    // controller!.animateTo(controller.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.ease);
                    messageList.add(
                      ChatMessage(
                        senderId: currentMessage['senderId'],
                        textMessage: currentMessage['textMessage'],
                        time: (currentMessage['time']),
                      ),
                    );
                    messageList.sort((a, b) {
                      return a.time.toString().toLowerCase().compareTo(b.time.toString().toLowerCase());
                    });
                  });
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    controller: _scrollController,
                    reverse: false,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: messageList[index].senderId == fAuth.currentUser!.uid ? const EdgeInsets.only(top: 20, left: 120, right: 15) : const EdgeInsets.only(top: 20, left: 15, right: 120),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: messageList[index].senderId == fAuth.currentUser!.uid ? Colors.blue : Colors.grey,
                          borderRadius: messageList[index].senderId == fAuth.currentUser!.uid
                              ? const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
                              : const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1,
                              blurRadius: 9.0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messageList[index].textMessage.toString(),
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              DateFormat.jm().format(DateTime.parse(messageList[index].time.toString())),
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No Message Found...',
                      style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w400),
                    ),
                  );
                }
              },
            ),
            // FirebaseAnimatedList(
            //   primary: true,
            //   physics: const BouncingScrollPhysics(),
            //   padding: const EdgeInsets.only(bottom: 80),
            //   query: ref,
            //   sort: (a, b) {
            //     return (a.value as Map)['time'].toString().toLowerCase().compareTo((b.value as Map)['time'].toString().toLowerCase());
            //   },
            //   reverse: false,
            //   shrinkWrap: true,
            //   itemBuilder: (context, snapshot, animation, index) {
            //     return Expanded(
            //       child: Container(
            //         margin: (snapshot.value as Map)["senderId"].toString() == fAuth.currentUser!.uid ? const EdgeInsets.only(top: 20, left: 120, right: 15) : const EdgeInsets.only(top: 20, left: 15, right: 120),
            //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //         decoration: BoxDecoration(
            //           color: (snapshot.value as Map)["senderId"].toString() == fAuth.currentUser!.uid ? Colors.blue : Colors.grey,
            //           borderRadius: (snapshot.value as Map)["senderId"].toString() == fAuth.currentUser!.uid
            //               ? const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
            //               : const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
            //           boxShadow: const [
            //             BoxShadow(
            //               color: Colors.black12,
            //               spreadRadius: 1,
            //               blurRadius: 9.0,
            //             ),
            //           ],
            //         ),
            //         child: Text(
            //           (snapshot.value as Map)["textMessage"].toString(),
            //           textAlign: TextAlign.justify,
            //           style: GoogleFonts.poppins(
            //             textStyle: const TextStyle(fontSize: 20, color: Colors.white),
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // ),
          ),
          Positioned(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                height: 60,
                color: Colors.white,
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.poppins(letterSpacing: 0.5),
                        controller: messageTextEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 30),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                          ),
                          filled: true,
                          hintText: "Type your message...",
                          hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 172, 170, 170),
                            ),
                          ),
                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        saveChatMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1,
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Image.asset("images/send.png", width: 30, height: 30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
