import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../business_logic/models/pain_model.dart';
import '../../../business_logic/services/firebase_auth_service.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';

class OnboardingController extends GetxController {
  RxList<PainType> selectedPainTypes = <PainType>[].obs;
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void toggleSelection(PainType painType) {
    if (selectedPainTypes.contains(painType)) {
      selectedPainTypes.remove(painType);
    } else {
      selectedPainTypes.add(painType);
    }
    update();
  }

  bool isItemSelected(PainType painType) {
    return selectedPainTypes.contains(painType);
  }

  Future<bool> updateUserInfo() async {
    try {
      final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();

      String? uid = Get.find<FirebaseAuthService>().user?.uid;
      Map<String, dynamic> userUpdatedData = {
        'status': 'COMPLETED',
        'name': nameController.text,
        'symptoms': selectedPainTypes.first.title,
      };
      if (uid != null) {
        await _firebaseFirestoreService.addOrUpdateUser(uid, userUpdatedData);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating user info in Firestore: $e');
      return false;
    }
  }

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }
    return true;
  }
}
