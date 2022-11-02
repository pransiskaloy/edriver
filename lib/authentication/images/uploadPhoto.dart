// import 'dart:io';
// import 'package:edriver/global/global.dart';
// import 'package:edriver/widgets/progress_dialog.dart';
// import 'package:edriver/widgets/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:permission_handler/permission_handler.dart';

// class UploadSelfPhoto extends StatefulWidget {
//   @override
//   _UploadSelfPhotoState createState() => _UploadSelfPhotoState();
// }

// class _UploadSelfPhotoState extends State<UploadSelfPhoto> {
//   String? imageUrl;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: SizeConfig.screenHeight! * 0.1),
//           Text(
//             "Profile Image",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: getProportionateScreenWidth(28),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: getProportionateScreenHeight(15)),
//           Text(
//             "Make sure that the image uploaded is clear.",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: getProportionateScreenWidth(12),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: SizeConfig.screenHeight! * 0.12),
//           (imageUrl != null)
//               ? Center(
//                   child: Container(
//                     height: 300,
//                     width: 300,
//                     child: Image.network(
//                       imageUrl!,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 )
//               : Center(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       chooseImage(currentFirebaseUser!.uid);
//                     },
//                     child: const Text('Choose Image'),
//                     style: OutlinedButton.styleFrom(
//                       primary: Colors.lightBlue,
//                     ),
//                   ),
//                 ),
//           SizedBox(height: getProportionateScreenHeight(15)),
//           (imageUrl != null)
//               ? Column(children: [
//                   OutlinedButton(
//                     onPressed: () {
//                       chooseImage(currentFirebaseUser!.uid);
//                     },
//                     child: Text('Choose Image'),
//                     style: OutlinedButton.styleFrom(
//                       primary: Colors.lightBlue,
//                     ),
//                   ),
//                   SizedBox(height: getProportionateScreenHeight(10)),
//                   OutlinedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Proceed'),
//                     style: OutlinedButton.styleFrom(
//                       primary: Colors.lightBlue,
//                     ),
//                   ),
//                 ])
//               : SizedBox(height: getProportionateScreenHeight(20)),
//         ],
//       ),
//     );
//   }

//   chooseImage(String uid) async {
//     final _picker = ImagePicker();
//     final _storage = FirebaseStorage.instance;
//     XFile? imageLiscense;
//     //Permissions
//     await Permission.photos.request();
//     var permissionStatus = await Permission.photos.status;
//     if (permissionStatus.isGranted) {
//       imageLiscense = await _picker.pickImage(source: ImageSource.gallery);
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) =>
//               ProgressDialog(message: 'Uploading.....'));
//       var file = File(imageLiscense!.path);
//       if (imageLiscense != null) {
//         var snapshot =
//             await _storage.ref().child('driverImages/$uid').putFile(file);
//         var downloadUrl = await snapshot.ref.getDownloadURL();
//         setState(() {
//           imageUrl = downloadUrl;
//         });
//       } else {
//         print('No image path');
//       }
//       Navigator.of(context).pop();
//     } else {
//       print('Permission Denied');
//     }
//   }
// }
