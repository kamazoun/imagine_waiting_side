import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserCredential? _userCredential;

  AuthController() {
    if (null == user) {
      signInAnonymously();
    }
  }

  signInAnonymously() async {
    _userCredential = await _auth.signInAnonymously();
  }

  signInWithPhoneNumberOnPhone() {}

  signInWithPhoneNumberOnWeb() {}
}
