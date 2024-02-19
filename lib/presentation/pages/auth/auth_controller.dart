import 'package:docare/presentation/pages/auth/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../business_logic/services/firebase_auth_service.dart';
import '../../widgets/utils.dart';
import '../welcome/welcome_page.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  Rxn<User> _firebaseUser = Rxn<User>();
  Rx<String> errorMessage = ''.obs;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    // Bind the stream to the _firebaseUser Rxn
    _firebaseUser.bindStream(_authService.firebaseUserStream);
    _firebaseUser.listen((user) {
      if (user == null) {
        _navigateToWelcome();
      }
    });
  }

  Future<void> signUp(String email, String password, int userType) async {
    await _authService.signUpWithEmailPassword(email, password, userType);
    showToast("Signed up successfully"); // Show toast for successful sign-up
    _navigateToHome();
  }

  Future<void> signIn(String email, String password) async {
    try {
      var user = await _authService.signInWithEmailPassword(email, password);
      if (user == null) {
        errorMessage.value = "Sign in failed. Check your email and password.";
      } else {
        showToast("Signed in successfully"); // Show toast for successful sign-in
        _navigateToHome();
      }
    } catch (e) {
      errorMessage.value = "An error occurred during sign in.";
    }
  }

  void _navigateToHome() {
    Get.offAll(() => HomePage()); // Navigate to the home screen
  }

  void _navigateToWelcome() {
    Get.offAll(() => WelcomePage()); // Navigate to the welcome screen
  }
}
