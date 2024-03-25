import 'package:docare/business_logic/services/firebase_firestore_service.dart';
import 'package:get/get.dart';

import '../../../business_logic/services/firebase_auth_service.dart';

class PatientProfileController extends GetxController {
  Future<void> logout() async {
    final _firebaseAuthService = Get.find<FirebaseAuthService>();
    final _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
    _firebaseFirestoreService.collectionPathFromUserType = null;
    await _firebaseAuthService.signOut();
  }
}
