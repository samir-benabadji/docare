import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_auth_service.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../widgets/utils.dart';
import '../welcome/welcome_page.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _firebaseAuthService = Get.find<FirebaseAuthService>();

  Rxn<User> _firebaseUser = Rxn<User>();
  Rx<String> errorMessage = ''.obs;

  User? get user => _firebaseUser.value;
  // Login
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Sign up
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController signUpConfirmPasswordController = TextEditingController();

  int selectedUserType = 2;

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  bool invalidEmail = false;
  bool obscureText = true;
  bool weakPassword = false;
  bool passwordContainsEmailOrName = false;
  bool emailAlreadyInUse = false;

  @override
  void onInit() {
    super.onInit();
    // Bind the stream to the _firebaseUser Rxn
    _firebaseUser.bindStream(_firebaseAuthService.firebaseUserStream);
    _firebaseUser.listen((user) {
      if (user == null) {
        _navigateToWelcomePage();
      }
    });
  }

  Future<void> signUp(String email, String password, int userType) async {
    String? uid = await _firebaseAuthService.signUpWithEmailPassword(email, password, userType);
    if (uid != null) {
      showToast("Signed up successfully");
      final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
      UserModel userModel = await _firebaseFirestoreService.getUserData(uid);
      navigatingTheUserDependingOnHisStatus(userModel);
    } else {
      showToast("Sign up failed");
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      var user = await _firebaseAuthService.signInWithEmailPassword(email, password);
      if (user == null) {
        errorMessage.value = "Sign in failed. Check your email and password.";
      } else {
        showToast("Signed in successfully"); // Show toast for successful sign-in
        final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
        UserModel userModel = await _firebaseFirestoreService.getUserData(user.uid);
        navigatingTheUserDependingOnHisStatus(userModel);
      }
    } catch (e) {
      errorMessage.value = "An error occurred during sign in.";
    }
  }

  void _navigateToWelcomePage() {
    Get.offAll(() => WelcomePage()); // Navigate to the welcome screen
  }

  bool validateLoginForm() {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  bool validateSignUpForm() {
    if (signUpFormKey.currentState!.validate()) {
      signUpFormKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }
}
