import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';

import '../Screens/OTPverification.dart';

class RegistrationController extends GetxController {
  final phoneController = TextEditingController();
  final selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  ).obs;

  var isLoading = false.obs;

  Future<void> sendOTP(BuildContext context) async {
    // Set the loading state to true
    isLoading.value = true;

    // Get the full phone number with the country code
    final phoneNumber = "+${selectedCountry.value.phoneCode}${phoneController.text}";

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verification if the device automatically receives the SMS code.
          print("Verification completed: $credential");
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure (e.g., invalid phone number).
          print("Verification Failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // Set the loading state to false when the OTP is sent
          isLoading.value = false;

          // Navigate to the OTP verification page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VerificationPage(verificationId: verificationId, phoneNumber: phoneNumber),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout (optional).
        },
      );
    } catch (e) {
      print("Error: $e");

      // Set the loading state to false if there's an error
      isLoading.value = false;
    }
  }
}
