import 'dart:async';

import 'package:get/get.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_auth_service.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../../initial_binding.dart';
import 'package:docare/presentation/widgets/utils.dart';
import '../welcome/welcome_page.dart';

class SplashController extends GetxController {
  Future<bool> isUserLoggedIn() async {
    try {
      await InitialBinding.initDependencies();
      final firebaseAuthService = Get.find<FirebaseAuthService>();
      if (firebaseAuthService.user != null) {
        final firebaseAuthService = Get.find<FirebaseAuthService>();
        final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
        UserModel user = await _firebaseFirestoreService.getUserData(firebaseAuthService.user!.uid);
        navigatingTheUserDependingOnHisStatus(user);
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
