import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:listify/Screens/registration.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 250,
                  width: 250,
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    color: Colors.purple.shade50,
                  ),
                  child: Image.asset(
                    "assests/welcome.png",
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Welcome,",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                      color: Colors.purple,
                      letterSpacing: 1.0),
                ),
                Text(
                  "Manage your task very easily!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 35,
                      color: Colors.white,
                      letterSpacing: 1.0),
                ),
                SizedBox(
                  height: 120,
                ),
                Text(
                  "Let's get started....",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.purple),
                ),
                Text(
                  "Never a better time than now to start....",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      wordSpacing: 2.0),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) {
                            return RegistrationPage();
                          },
                        ));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple), // Change the background color
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Change the text color
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(fontSize: 16, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
