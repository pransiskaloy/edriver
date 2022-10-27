import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String text;
  final press;
  final Color color;
  const TransparentButton({
    required this.text,
    required this.press,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            primary: Colors.transparent,
            shadowColor: Colors.black),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontFamily: 'Muli',
          ),
        ),
      ),
    );
  }
}
