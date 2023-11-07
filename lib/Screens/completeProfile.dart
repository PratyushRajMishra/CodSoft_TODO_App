import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../model/UIHelper.dart';
import '../model/UserModel.dart';
import 'homePage.dart';

class CompleteProfilePage extends StatefulWidget {
  final UserModel userModel;
  CompleteProfilePage({required this.userModel, Key? key}) : super(key: key);

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  UserModel? userModel; // Create a variable to hold the userModel

  void selectImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload profile picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: Icon(Icons.photo),
                title: Text('Select from gallery'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
              ),
            ],
          ),
        );
      },
    );
  }

  void checkValues() {
    String fullname = fullNameController.text.trim();
    String about = aboutController.text.trim();
    String mobile = mobileController.text.trim();

    if (fullname.isEmpty || about.isEmpty || mobile.isEmpty || imageFile == null) {
      UIHelper.shoeAlertDialog(
        context,
        "Incomplete Data",
        "Please fill all the fields and upload a profile picture",
      );
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UIHelper.showLoadingDialog(context, "Setting profile picture...");

    try {
      // Upload the profile picture to Firebase Storage
      final imageRef = FirebaseStorage.instance
          .ref("profilepictures")
          .child(widget.userModel.uid.toString());

      await imageRef.putFile(imageFile!);
      final imageUrl = await imageRef.getDownloadURL();

      // Update user data
      widget.userModel.fullname = fullNameController.text.trim();
      widget.userModel.about = aboutController.text.trim();
      widget.userModel.mobile = mobileController.text.trim();
      widget.userModel.profilepic = imageUrl;

      // Update the user data in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .set(widget.userModel.toMap())
          .then((value) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage(userModel: widget.userModel);
            },
          ),
        );
      });
    } catch (error) {
      // Handle the error
      UIHelper.shoeAlertDialog(context, "Error", "Failed to upload profile picture");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: ListView(
              children: [
                SizedBox(
                  height: 50,
                ),
                CupertinoButton(
                  onPressed: () {
                    showPhotoOptions();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 90,
                    backgroundImage:
                    (imageFile != null) ? FileImage(imageFile!) : null,
                    child: (imageFile == null)
                        ? Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: 'Full Name',
                    labelStyle: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: aboutController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: 'About',
                    labelStyle: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: 'Mobile no.',
                    labelStyle: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                CupertinoButton(
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  color: Colors.purple,
                  onPressed: () {
                    checkValues();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
