import 'package:docare/presentation/pages/auth/auth_controller.dart';
import 'package:docare/presentation/pages/auth/home/home_controller.dart';
import 'package:docare/presentation/pages/onboarding/onboarding_controller.dart';
import 'package:get/get.dart';

import 'business_logic/services/firebase_auth_service.dart';
import 'business_logic/services/firebase_firestore_service.dart';

class InitialBinding {
  static Future<bool> initDependencies() async {
    // services
    // Get.put<FirebaseStorageService>(FirebaseStorageService(), permanent: true);
    Get.put<FirebaseAuthService>(FirebaseAuthService(), permanent: true);
    Get.put<FirebaseFirestoreService>(FirebaseFirestoreService(), permanent: true);

    // controllers
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<OnboardingController>(OnboardingController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    // repositories

    return true;
  }
}
