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
  // options
  RxList<SelectedOption> selectedOptions = <SelectedOption>[].obs;
  List<String> options = [
    "IRM (Imagerie par Résonance Magnétique)",
    "Scanner (Tomodensitométrie)",
    "Radiographie (X-ray machine)",
    "Échographe (Échographie médicale)",
    "Colposcope (Colposcopie)",
    "Stéthoscope",
    "Otoscope et Ophtalmoscope",
    "Électrocardiographe (ECG)",
    "Appareil de mesure de la pression artérielle",
    "Analyseur sanguin"
  ];
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  UserModel? userModel;

  @override
  void onInit() {
    getUserDataModel();
    super.onInit();
  }

  void sortOptions() {
    options.sort((a, b) {
      bool aSelected = selectedOptions.any((option) => option.name == a);
      bool bSelected = selectedOptions.any((option) => option.name == b);

      if (aSelected && !bSelected) {
        return -1;
      } else if (!aSelected && bSelected) {
        return 1;
      } else {
        return 0;
      }
    });
    update();
  }

  void getUserDataModel() async {
    final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
    final FirebaseAuthService _firebaseAuthService = Get.find<FirebaseAuthService>();

    if (_firebaseAuthService.user != null) userModel = await _firebaseFirestoreService.getUserData(_firebaseAuthService.user!.uid);
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

  void toggleOptionSelection(String option) {
    bool alreadySelected = selectedOptions.any((element) => element.name == option);

    if (alreadySelected) {
      selectedOptions.removeWhere((element) => element.name == option);
    } else {
      SelectedOption newOption = SelectedOption(option);
      selectedOptions.add(newOption);
    }
    sortOptions();
  }

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }
    return true;
  }
}

class SelectedOption {
  String name;
  double price;

  SelectedOption(this.name, {this.price = 0});
}
