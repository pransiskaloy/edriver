import 'dart:io';
import 'package:edriver/authentication/images/liscense_photo.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadSelfPhoto extends StatefulWidget {
  @override
  _UploadSelfPhotoState createState() => _UploadSelfPhotoState();
}

class _UploadSelfPhotoState extends State<UploadSelfPhoto> {
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
          Image.asset("images/profile.png"),
          (imageUrl != null)
              ? Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(imageUrl!),
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage("images/profile2.png"),
                      ),
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LiscensePhoto()));
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
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => ProgressDialog(message: 'Uploading.....'));

    if (file != null) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child('profileImage');
      Reference referenceUpload = referenceDirImage.child(uid);
      try {
        await referenceUpload.putFile(File(file.path));
        var downloadurl = await referenceUpload.getDownloadURL();
        setState(() {
          imageUrl = downloadurl;
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
