import 'dart:io';
import 'package:edriver/authentication/images/liscense_photo.dart';
import 'package:edriver/global/global.dart';
import 'package:edriver/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
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
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            "Profile Image",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Make sure that the image uploaded is clear.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          (imageUrl != null)
              ? Center(
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Center(
                  child: OutlinedButton(
                    onPressed: () {
                      chooseImage(currentFirebaseUser!.uid);
                    },
                    child: const Text('Choose Image'),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.lightBlue,
                    ),
                  ),
                ),
          const SizedBox(height: 15),
          (imageUrl != null)
              ? Column(children: [
                  OutlinedButton(
                    onPressed: () {
                      chooseImage(currentFirebaseUser!.uid);
                    },
                    child: const Text('Choose Image'),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.lightBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => LiscensePhoto()));
                    },
                    child: const Text('Proceed'),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.lightBlue,
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
