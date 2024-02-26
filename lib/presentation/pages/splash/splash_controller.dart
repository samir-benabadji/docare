import 'dart:async';

import 'package:docare/presentation/pages/auth/home/home_page.dart';
import 'package:get/get.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_auth_service.dart';
import '../../../initial_binding.dart';
import '../welcome/welcome_page.dart';

class SplashController extends GetxController {
  Future<bool> isUserLoggedIn() async {
    try {
      await InitialBinding.initDependencies();
      final firebaseAuthService = Get.find<FirebaseAuthService>();
      if (firebaseAuthService.user != null) {
        final firebaseAuthService = Get.find<FirebaseAuthService>();
        UserModel user = await firebaseAuthService.getUserData(firebaseAuthService.user!.uid);
        switch (user.status) {
          case 'INCOMPLETE':
            //  Get.off(() => NamePage()); 
            break;
          case 'PENDING':
            //  Get.off(() => PendingPage()); 
            break;
          case 'APPROVED':
            Get.off(() => HomePage()); 
            break;
          case 'REJECTED':
            // Get.off(() => RejectedPage()); 
            break;
          case 'BANNED':
            Get.off(() => WelcomePage()); 
            break;
          case 'DISABLED':
            Get.off(() => WelcomePage());
            break;
          case 'DELETED':
            Get.off(() => WelcomePage()); 
            break;
          default:
            Get.off(() => WelcomePage());
            break;
        }
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
