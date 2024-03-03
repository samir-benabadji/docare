import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_auth_service.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../widgets/utils.dart';
import '../onboarding/onboarding_phone_number_verification_page.dart';
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

  // Phone number
  PhoneNumber? defaultCountryPhone;
  PhoneNumber currentPhoneNumber = PhoneNumber();
  bool isValidNumber = false;
  TextEditingController textEditingController = TextEditingController();
  String? verificationFailedWithPhone;
  bool isIncorrectCode = false;
  bool isFirstTimeTrying = true;
  String otpCode = '';
  String? verificationId;

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

  Future<PhoneNumber?> getDefaultCountry() async {
    final phoneNumberBasedOnIp = await getCountryFromCurrentIP();
    if (phoneNumberBasedOnIp != null) return phoneNumberBasedOnIp;
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
    } catch (_) {
      return null;
    }

    return PhoneNumber(isoCode: platformVersion ?? Platform.localeName.split('_').last);
  }

  Future<PhoneNumber?> getCountryFromCurrentIP() async {
    try {
      var _res = await Dio(
        BaseOptions(
          connectTimeout: 4000,
          receiveTimeout: 4000,
          sendTimeout: 4000,
        ),
      ).get(
        "http://ip-api.com/json",
      );
      if (_res.statusCode == 200 || _res.statusCode == 201) {
        String _cc = _res.data["countryCode"];
        if (_cc.isEmpty) {
          return null;
        } else {
          return PhoneNumber(isoCode: _cc);
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> verifyPhoneNumber({
    String? customPhoneNumber,
    bool gotoOTPPage = true,
    bool skipFirebaseAuthSettings = false,
  }) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
      if (gotoOTPPage) {
        Get.to(() => OnboardingPhoneNumberVerificationPage());
      }
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      showToast("Phone number verification failed. Code: ${e.code}. Message: ${e.message}");
    };

    final PhoneCodeSent codeSent = (String verId, int? resendToken) async {
      this.verificationId = verId; // Storing verification ID here
      if (gotoOTPPage) {
        Get.to(() => OnboardingPhoneNumberVerificationPage());
      }
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verId) {
      this.verificationId = verId; // Storing verification ID here for auto retrieval
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: customPhoneNumber ?? currentPhoneNumber.phoneNumber!,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      showToast("Failed to Verify Phone Number: ${e.toString()}");
    }
  }

  void verifyOtp({String? otp, bool testingAccount = false}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    if (verificationId == null || otp == null) {
      showToast("Verification ID or OTP is null");
      return;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    );

    try {
      await _auth.signInWithCredential(credential);
      showToast("Phone number verified successfully!");
      // Success
    } catch (e) {
      showToast("Failed to Verify OTP: ${e.toString()}");
      // Handle errors
    }
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
