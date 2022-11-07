import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton3 extends StatelessWidget {
  final String title;
  final onPressed;
  final Color color;
  const MyButton3({required this.title, required this.onPressed, required this.color});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(25),
          ),
          primary: color,
          onPrimary: Colors.white),
      onPressed: onPressed,
      child: SizedBox(
        height: 50,
        width: 200,
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
            // style: const TextStyle(
            //     fontFamily: 'Muli', fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
