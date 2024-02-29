// Helper method to show toast messages
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../business_logic/models/user_model.dart';
import '../pages/auth/home/home_page.dart';
import '../pages/onboarding/onboarding_medical_speciality.dart';
import '../pages/onboarding/onboarding_symptoms_page.dart';
import '../pages/welcome/welcome_page.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void navigatingTheUserDependingOnHisStatus(UserModel user) {
  switch (user.status) {
    case 'INCOMPLETE':
      user.userType == 1
          ? Get.offAll(() => OnboardingMedicalSpecialityPage())
          : Get.offAll(() => OnboardingSymptomsPage());
      break;
    case 'PENDING':
      //  Get.off(() => PendingPage());
      break;
    case 'COMPLETED':
      Get.off(() => HomePage());
      break;
    case 'REJECTED':
      //   Get.off(() => RejectedPage());
      break;
    case 'BANNED':
    case 'DISABLED':
    case 'DELETED':
      Get.off(() => WelcomePage());
      break;
    default:
      Get.off(() => WelcomePage());
      break;
  }
}
