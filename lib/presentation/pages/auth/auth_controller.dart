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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool invalidEmail = false;
  bool obscureText = true;
  bool weakPassword = false;
  bool passwordContainsEmailOrName = false;
  bool emailAlreadyInUse = false;

  @override
  void onInit() {
    super.onInit();
    // Bind the stream to the _firebaseUser Rxn
    _firebaseUser.bindStream(_authService.firebaseUserStream);
    _firebaseUser.listen((user) {
      if (user == null) {
        _navigateToWelcomePage();
      }
    });
  }

  Future<void> signUp(String email, String password, int userType) async {
    await _authService.signUpWithEmailPassword(email, password, userType);
    showToast("Signed up successfully"); // Show toast for successful sign-up
    _navigateToOnboardingPage();
  }

  Future<void> signIn(String email, String password) async {
    try {
      var user = await _authService.signInWithEmailPassword(email, password);
      if (user == null) {
        errorMessage.value = "Sign in failed. Check your email and password.";
      } else {
        showToast("Signed in successfully"); // Show toast for successful sign-in
        _navigateToHomePage();
      }
    } catch (e) {
      errorMessage.value = "An error occurred during sign in.";
    }
  }

  void _navigateToHomePage() {
    Get.offAll(() => HomePage()); // Navigate to the home screen
  }

  void _navigateToWelcomePage() {
    Get.offAll(() => WelcomePage()); // Navigate to the welcome screen
  }

  void _navigateToOnboardingPage() {
    // Get.offAll(() => WelcomePage()); // Navigate to the welcome screen
  }
}
