import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'FirebaseHelper.dart';
import 'UserModel.dart';

class UserController extends GetxController {
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.value = FirebaseAuth.instance.currentUser;
    fetchUserModel();
  }

  Future<void> fetchUserModel() async {
    if (firebaseUser.value != null) {
      final thisUserModel = await FirebaseHelper.getUserModelById(firebaseUser.value!.uid);
      if (thisUserModel != null) {
        userModel.value = thisUserModel;
      } else {
        // User data doesn't exist in Firestore, set a default UserModel
        userModel.value = UserModel(phoneNumber: firebaseUser.value!.phoneNumber.toString());
      }
    }
  }
}
