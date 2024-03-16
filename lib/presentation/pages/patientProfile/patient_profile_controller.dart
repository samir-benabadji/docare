import 'package:get/get.dart';

import '../../../business_logic/services/firebase_auth_service.dart';

class PatientProfileController extends GetxController {
  Future<void> logout() async {
    final _firebaseAuthService = Get.find<FirebaseAuthService>();
    await _firebaseAuthService.signOut();
  }
}
