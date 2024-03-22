import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../widgets/utils.dart';
import '../auth/auth_controller.dart';

class PatientDetailsController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
  final authController = Get.find<AuthController>();

  final TextEditingController textEditingNameController = TextEditingController();
  String? gender;
  DateTime birthDate = DateTime(
    DateTime.now().year - 18,
    DateTime.now().month,
    DateTime.now().day,
    10,
    20,
  );

  Future<void> updateUserData() async {
    try {
      if (_firebaseFirestoreService.getUserModel != null) {
        Map<String, dynamic> userData = {
          'name': textEditingNameController.text,
          'phoneNumber': authController.currentPhoneNumber.phoneNumber,
          'phoneNumberDialCode': authController.currentPhoneNumber.dialCode,
          'gender': gender,
          'birthDate': birthDate,
          'userType': _firebaseFirestoreService.getUserModel!.userType,
        };

        bool isSuccess = await _firebaseFirestoreService.addOrUpdateUser(
          _firebaseFirestoreService.getUserModel!.uid,
          userData,
          isUpdatingUser: true,
        );

        if (isSuccess) {
          showToast('Information updated successfully');
        } else {
          showToast('Failed to update information. Please try again later.');
        }
      } else {
        showToast('User information not found. Cannot update.');
      }
    } catch (e) {
      print('Error updating or adding user data: $e');
      showToast('Failed to update information. Please try again later.');
    }
  }

  @override
  void onInit() {
    if (_firebaseFirestoreService.getUserModel != null) {
      if (_firebaseFirestoreService.getUserModel!.name != null)
        textEditingNameController.text = _firebaseFirestoreService.getUserModel!.name!;
      if (_firebaseFirestoreService.getUserModel!.phoneNumber != null &&
          _firebaseFirestoreService.getUserModel!.phoneNumberDialCode != null)
        authController.currentPhoneNumber = PhoneNumber(
          phoneNumber: _firebaseFirestoreService.getUserModel!.phoneNumber!,
          dialCode: _firebaseFirestoreService.getUserModel!.phoneNumberDialCode,
        );

      gender = _firebaseFirestoreService.getUserModel!.gender;
    }
    super.onInit();
  }
}
