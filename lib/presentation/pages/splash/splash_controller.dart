import 'dart:async';

import 'package:docare/presentation/pages/auth/home/home_page.dart';
import 'package:get/get.dart';

import '../../../business_logic/services/firebase_auth_service.dart';
import '../../../initial_binding.dart';
import '../welcome/welcome_page.dart';

class SplashController extends GetxController {
  Future<bool> isUserLoggedIn() async {
    try {
      await InitialBinding.initDependencies();
      final firebaseAuthService = Get.find<FirebaseAuthService>();
      if (firebaseAuthService.user != null) {
        Get.off(() => HomePage());
      } else {
        Get.off(() => WelcomePage());
      }
    } catch (e) {
      print(e);
      Get.off(() => WelcomePage());
    }

    return false;
  }
}
