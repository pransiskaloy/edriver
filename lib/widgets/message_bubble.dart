import 'package:edriver/global/global.dart';
import 'package:edriver/models/message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubble extends StatefulWidget {
  ChatMessage? chatMessage;

  MessageBubble({this.chatMessage});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: widget.chatMessage!.senderId! == fAuth.currentUser!.uid ? const EdgeInsets.only(top: 20, left: 120, right: 15) : const EdgeInsets.only(top: 20, left: 15, right: 120),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: widget.chatMessage!.senderId! == fAuth.currentUser!.uid ? Colors.blue : Colors.grey,
          borderRadius: widget.chatMessage!.senderId! == fAuth.currentUser!.uid
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
          children: [
            Text(
              widget.chatMessage!.textMessage!,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Text(
              widget.chatMessage!.time!.toString(),
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
