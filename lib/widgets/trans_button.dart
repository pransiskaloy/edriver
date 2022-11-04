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
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            primary: color,
            onSurface: color),
        onPressed: press,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black54,
            fontFamily: 'Muli',
          ),
        ),
      ),
    );
  }
}
