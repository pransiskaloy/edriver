import 'dart:io';

import 'package:edriver/authentication/carinfo_screen.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class OrCr extends StatefulWidget {
  const OrCr({Key? key}) : super(key: key);

  @override
  State<OrCr> createState() => _OrCrState();
}

class _OrCrState extends State<OrCr> {
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    currentFirebaseUser = fAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.asset("images/orcr.png"),
          (imageUrl != null)
              ? Center(
                  child: SizedBox(
                    height: 200,
                    width: 300,
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "images/license1.png",
                        height: 200,
                        width: 250,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Make sure the image uploaded is clear.",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          chooseImage(currentFirebaseUser!.uid);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * .4,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "Upload Image",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                letterSpacing: 1,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          primary: Colors.lightBlue,
                          textStyle: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          const SizedBox(height: 15),
          (imageUrl != null)
              ? Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Make sure the image uploaded is clear.",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      chooseImage(currentFirebaseUser!.uid);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .4,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Upload Image",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      primary: Colors.lightBlue,
                      textStyle: const TextStyle(
                        letterSpacing: 1,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => CarInfoScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF4F6CAD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // <-- Radius
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .4,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Proceed",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ])
              : const SizedBox(height: 20),
        ],
      ),
    );
  }

  chooseImage(String uid) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(message: 'Uploading.....'));

    if (file != null) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child('orcrimage');
      Reference referenceUpload = referenceDirImage.child(uid);

      DatabaseReference imageRef = FirebaseDatabase.instance
          .ref()
          .child("drivers/${currentFirebaseUser!.uid}/orcrimage");
      try {
        await referenceUpload.putFile(File(file.path));
        var downloadurl = await referenceUpload.getDownloadURL();
        setState(() {
          imageUrl = downloadurl;
          imageRef.set(downloadurl);
        });
      } catch (e) {
        // ignore: avoid_print
        print('No image path');
      }
    } else {
      return;
    }
    Navigator.of(context).pop();
  }
}
