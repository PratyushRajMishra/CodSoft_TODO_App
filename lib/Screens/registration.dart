import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import '../model/RegistrationController.dart';

class RegistrationPage extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  padding: EdgeInsets.all(50.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.shade50,
                  ),
                  child: Image.asset(
                      "assests/registration.png"), // Make sure the image path is correct
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Register",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.purple,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Add your phone number. We'll send you a verification code",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Builder(
                    builder: (context) {
                      return Column(
                        children: [
                          Obx(() {
                            bool isPhoneValid =
                                controller.phoneController.text.length > 9;
                            return TextFormField(
                              cursorColor: Colors.purple,
                              controller: controller.phoneController,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              onChanged: (value) {
                                controller.phoneController.text = value;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.white70,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                prefixIcon: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        onSelect: (Country value) {
                                          controller.selectedCountry.value =
                                              value;
                                        },
                                        countryListTheme: CountryListThemeData(
                                          bottomSheetHeight: 550,
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${controller.selectedCountry.value.flagEmoji} + ${controller.selectedCountry.value.phoneCode}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                suffixIcon: isPhoneValid
                                    ? Container(
                                        height: 20,
                                        width: 20,
                                        margin: EdgeInsets.all(20.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.sendOTP(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.purple),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          // Show the circular progress indicator while loading
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  )),
                              SizedBox(width: 10),
                              Text("OTP Sending...",
                                  style: TextStyle(
                                      fontSize: 16, letterSpacing: 1.0)),
                            ],
                          );
                        } else {
                          return Text("Send OTP",
                              style:
                                  TextStyle(fontSize: 16, letterSpacing: 1.0));
                        }
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
