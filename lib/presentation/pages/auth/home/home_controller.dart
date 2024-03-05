import 'package:get/get.dart';

import '../../../../business_logic/models/user_model.dart';
import '../../../../business_logic/services/firebase_auth_service.dart';

class HomeController extends GetxController {
  final UserModel? userModel;

  HomeController({this.userModel});

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> logout() async {
    final _firebaseAuthService = Get.find<FirebaseAuthService>();
    await _firebaseAuthService.signOut();
  }
}
