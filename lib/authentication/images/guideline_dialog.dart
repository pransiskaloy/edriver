import 'package:flutter/material.dart';

import '../../widgets/TaxiOutlineButton.dart';

class GuideDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Important Notice!',
                  style: TextStyle(fontSize: 22.0, fontFamily: 'Muli'),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'We do not have camera support yet. Make sure you have\n'
                    'these images already taken ready to be uploaded. Make sure it is clear and legit.\n'
                    '-License Image\nImage of Self\nPicture with License\nCar Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Muli', fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 200,
                  child: TaxiOutlineButton(
                    title: 'Proceed',
                    color: Colors.grey.shade400,
                    onPressed: () {
                      Navigator.of(context).pop('proceedna');
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
