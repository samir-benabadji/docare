import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  TextEditingController textEditingPhoneController = TextEditingController();
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
      if (Get.context != null) {
        showToast("${AppLocalizations.of(Get.context!)!.phoneVerificationFailedText} ${e.code}. ${e.message}");
      }
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
      if (Get.context != null) {
        showToast("${AppLocalizations.of(Get.context!)!.failedToVerifyPhoneNumberText} ${e.toString()}");
      }
    }
  }

  Future<bool> verifyOtp({String? otp, bool testingAccount = false}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    if (verificationId == null || otp == null) {
      if (Get.context != null) {
        showToast(AppLocalizations.of(Get.context!)!.verificationIdOrOTPNullText);
      }
      return false; // Failure
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    );

    try {
      await _auth.signInWithCredential(credential);
      if (Get.context != null) {
        showToast(AppLocalizations.of(Get.context!)!.phoneVerifiedSuccessfullyText);
      }
      return true; // Success
    } catch (e) {
      if (Get.context != null) {
        showToast("${AppLocalizations.of(Get.context!)!.failedToVerifyOTPText} ${e.toString()}");
      }
      return false; // Failure
    }
  }

  Future<void> signUp(String email, String password, int userType) async {
    String? uid = await _firebaseAuthService.signUpWithEmailPassword(email, password, userType);
    if (uid != null) {
      if (Get.context != null) {
        showToast(AppLocalizations.of(Get.context!)!.signUpSuccessText);
      }
      final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
      UserModel? userModel = await _firebaseFirestoreService.getUserData(uid);
      if (userModel != null) {
        navigatingTheUserDependingOnHisStatus(userModel);
      } else {
        if (Get.context != null) {
          showToast(AppLocalizations.of(Get.context!)!.userDataRetrievalFailedText);
        }
      }
    } else {
      if (Get.context != null) {
        showToast(AppLocalizations.of(Get.context!)!.signUpFailedText);
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      var user = await _firebaseAuthService.signInWithEmailPassword(email, password);
      if (user == null) {
        if (Get.context != null) {
          errorMessage.value = AppLocalizations.of(Get.context!)!.signInFailedMessage;
        }
      } else {
        if (Get.context != null) {
          showToast(AppLocalizations.of(Get.context!)!.signInSuccessText);
        }
        final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
        UserModel? userModel = await _firebaseFirestoreService.getUserData(user.uid);
        if (userModel != null) {
          navigatingTheUserDependingOnHisStatus(userModel);
        } else {
          if (Get.context != null) {
            errorMessage.value = AppLocalizations.of(Get.context!)!.userDataRetrievalFailedText;
          }
        }
      }
    } catch (e) {
      if (Get.context != null) {
        errorMessage.value = AppLocalizations.of(Get.context!)!.signInErrorMessage;
      }
    }
  }

  void _navigateToWelcomePage() {
    Get.offAll(() => WelcomePage());
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

  void clearControllers() {
    loginEmailController.text = "";
    loginPasswordController.text = "";
    signUpEmailController.text = "";
    signUpPasswordController.text = "";
    signUpConfirmPasswordController.text = "";
    loginFormKey.currentState?.reset();
  }
}
