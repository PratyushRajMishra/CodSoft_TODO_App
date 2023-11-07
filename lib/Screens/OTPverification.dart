import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listify/Screens/completeProfile.dart';
import 'package:pinput/pinput.dart';

import '../model/FirebaseHelper.dart';
import '../model/UserModel.dart';
import 'homePage.dart';

class VerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerificationPage({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String? otpCode;
  bool isVerifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.shade50,
                    ),
                    child: Image.asset("assests/registration.png"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Verification",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.purple,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter the OTP sent to your phone",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white70),
                      ),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onChanged: (value) {
                      otpCode = value;
                    },
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isVerifying
                          ? null
                          : () {
                        if (otpCode != null && otpCode!.length == 6) {
                          final credential = PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpCode!,
                          );
                          verifyOTP(context, credential);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Enter a valid 6-digit code"),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: isVerifying
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Verifying...",
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      )
                          : Text(
                        'Verify',
                        style:
                        TextStyle(fontSize: 16, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyOTP(BuildContext context,
      PhoneAuthCredential credential) async {
    setState(() {
      isVerifying = true;
    });

    try {
      final authCredential = await FirebaseAuth.instance.signInWithCredential(
          credential);
      if (authCredential.user != null) {
        // Fetch the user data and create a UserModel
        final user = authCredential.user;

        // Check if the user's data exists in Firestore
        final userModel = await FirebaseHelper.getUserModelById(
            user?.uid ?? "");

        if (userModel != null) {
          // User data already exists, navigate to HomePage
          final NavigatorState navigator = Navigator.of(context);
          navigator.popUntil((route) => route.isFirst);
          navigator.push(
            MaterialPageRoute(
              builder: (context) {
                return HomePage(userModel: userModel);
              },
            ),
          );
        } else {
          // User data doesn't exist, navigate to CompleteProfilePage
          final userModel = UserModel(
            uid: user?.uid ?? "",
            phoneNumber: widget.phoneNumber,
          );
          final NavigatorState navigator = Navigator.of(context);
          navigator.popUntil((route) => route.isFirst);
          navigator.push(
            MaterialPageRoute(
              builder: (context) {
                return CompleteProfilePage(userModel: userModel);
              },
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid OTP"),
          ),
        );
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error verifying OTP: $e"),
        ),
      );
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }
}
