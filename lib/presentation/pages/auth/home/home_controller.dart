import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../business_logic/services/firebase_auth_service.dart';

class HomeController extends GetxController {
  final _firebaseAuthService = Get.find<FirebaseAuthService>();

  Stream<DocumentSnapshot> userDataStream() {
    return FirebaseFirestore.instance.collection('users').doc(_firebaseAuthService.user?.uid).snapshots();
  }

  Future<void> logout() async {
    await _firebaseAuthService.signOut();
    //Get.offAll(() => WelcomePage(key: UniqueKey()));
  }
}
