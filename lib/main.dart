import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/welcome.dart';
import 'Screens/homePage.dart';
import 'firebase_options.dart'; // You should replace this with your Firebase options file
import 'model/UserController.dart';
import 'model/UserModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize UserController here
  Get.put(UserController());

  final prefs = await SharedPreferences.getInstance();
  final isLogin = prefs.getBool('isLogin') ?? false;

  runApp(isLogin ? MyAppLoggedIn() : MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
            .copyWith(secondary: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: Obx(() {
        final userController = Get.find<UserController>();
        final userModel = userController.userModel.value ??
            UserModel(phoneNumber: ''); // Get the userModel or use a default UserModel
        return userController.firebaseUser.value != null
            ? HomePage(userModel: userModel)
            : WelcomePage();
      }),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final userModel = userController.userModel.value; // Get the userModel

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
            .copyWith(secondary: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: Obx(() {
        if (userModel != null) {
          return HomePage(userModel: userModel);
        } else {
          return const WelcomePage();
        }
      }),
    );
  }
}
