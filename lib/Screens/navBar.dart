import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:listify/Screens/about.dart';
import 'package:listify/Screens/feedback.dart';
import 'package:listify/Screens/profile.dart';
import 'package:listify/Screens/registration.dart';
import 'package:listify/Screens/setting.dart';

import '../model/UserModel.dart';



class NavbarPage extends StatefulWidget {
  final UserModel userModel;

  const NavbarPage({super.key, required this.userModel});


  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade400,
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.userModel.profilepic.toString(),
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) {
                        // Handle errors here, for example, display a default image or show an error message.
                        return CircleAvatar(
                          child: Icon(CupertinoIcons.person, color: Colors.white),
                        );
                      },
                      placeholder: (context, url) {
                        // You can also add a placeholder image while the image is loading.
                        return CircularProgressIndicator(color: Colors.white54,); // or any other loading indicator.
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    widget.userModel.fullname.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    widget.userModel.mobile.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2.0),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Get.to(
                                  () => ProfilePage(userModel: widget.userModel),
                              transition: Transition.rightToLeft,
                            );
                          },
                          leading: const Icon(
                            Icons.person_2_outlined,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Get.to(
                                  () => SettingPage(userModel: widget.userModel),
                              transition: Transition.rightToLeft,
                            );
                          },
                          leading: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Settings',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Get.to(
                                  () => FeedbackPage(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          leading: const Icon(
                            Icons.feedback_outlined,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Feedback',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Get.to(
                                  () => AboutPage(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          leading: const Icon(
                            Icons.account_balance_outlined,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'About',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Get.offAll(RegistrationPage());
                            }).catchError((error) {
                              print("Error signing out: $error");
                            });
                          },
                          leading: const Icon(
                            Icons.logout_outlined,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}