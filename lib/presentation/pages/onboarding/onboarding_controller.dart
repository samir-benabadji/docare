import 'package:docare/business_logic/models/speciality_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../business_logic/models/pain_model.dart';
import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_auth_service.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';

class OnboardingController extends GetxController {
  RxList<PainType> selectedPainTypes = <PainType>[].obs;
  Rx<SpecialityType> selectedSpecialityType = SpecialityType("", "").obs;
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel? userModel;

  @override
  void onInit() {
    getUserDataModel();
    super.onInit();
  }

  void getUserDataModel() async {
    final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
    final FirebaseAuthService _firebaseAuthService = Get.find<FirebaseAuthService>();

    if (_firebaseAuthService.user != null)
      userModel = await _firebaseFirestoreService.getUserData(_firebaseAuthService.user!.uid);
    update();
  }

  void togglePainTypeSelection(PainType painType) {
    if (selectedPainTypes.contains(painType)) {
      selectedPainTypes.remove(painType);
    } else {
      selectedPainTypes.add(painType);
    }
    update();
  }

  void setMedicalSpeciality(SpecialityType specialityType) {
    selectedSpecialityType.value = specialityType;
    update();
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
