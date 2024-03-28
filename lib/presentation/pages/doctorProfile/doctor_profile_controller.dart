import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../business_logic/models/appointment_model.dart';
import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../widgets/utils.dart';

class DoctorProfileController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();

  DateTime currentSelectedMonth = DateTime.now();
  DateTime currentSelectedDay = DateTime.now();
  String currentSelectedSessionStartAt = "";

  List<String> doctorExtraInformations = ["Appoitement", "Clinic"];
  String currentSelectedDoctorExtraInformation = "";

  Map<String, dynamic>? sessionOption;

  DateTime get selectedDate => currentSelectedMonth;
  DateTime get highlightedDate => currentSelectedDay;

  // Booking an appointment
  String startAtAppointment = '';
  String endAtAppointment = '';
  TextEditingController textEditingProblemController = TextEditingController();
  int? timestamp;

  void previousMonth() {
    currentSelectedMonth = DateTime(currentSelectedMonth.year, currentSelectedMonth.month - 1, 1);
    update();
  }

  void nextMonth() {
    currentSelectedMonth = DateTime(currentSelectedMonth.year, currentSelectedMonth.month + 1, 1);
    update();
  }

  void createAppointment({
    required UserModel doctorUserModel,
    required Map<String, dynamic> optionPicked,
  }) async {
    try {
      if (_firebaseFirestoreService.getUserModel == null) {
        showToast("User's information is not available.");
        return;
      }

      if (_firebaseFirestoreService.getUserModel?.userType != 2) {
        showToast('Only patients can make appointments.');
        return;
      }

      if (startAtAppointment.isEmpty || endAtAppointment.isEmpty) {
        showToast('Doctor has not provided appointment timings.');
        return;
      }
      if (timestamp == null) {
        showToast('Doctor has not provided appointment date.');
        return;
      }
      if (textEditingProblemController.text.isEmpty) {
        showToast('Please provide the problem description.');
        return;
      }

      String appointmentId = Uuid().v4();
      final appointment = AppointmentModel(
        patientId: _firebaseFirestoreService.getUserModel!.uid,
        doctorId: doctorUserModel.uid,
        optionPicked: optionPicked,
        startAt: startAtAppointment,
        appointmentTimeStamp: timestamp!,
        endAt: endAtAppointment,
        createdAt: Timestamp.now(),
        doctorName: doctorUserModel.name ?? "Unknown",
        doctorProfileImageUrl: doctorUserModel.profileImageUrl ?? "",
        doctorSpecialty: doctorUserModel.medicalSpeciality ?? "Unknown",
        appointmentStatus: "PENDING",
        patientName: _firebaseFirestoreService.getUserModel!.name,
        patientEmail: _firebaseFirestoreService.getUserModel!.email,
        patientPhoneNumber: _firebaseFirestoreService.getUserModel!.phoneNumber,
        patientProfileImageUrl: _firebaseFirestoreService.getUserModel!.profileImageUrl,
        patientProblem: textEditingProblemController.text,
        id: appointmentId,
      );

      sessionOption = null;
      textEditingProblemController.clear();

      await _firebaseFirestoreService.checkAppointmentAvailability(appointment);
    } catch (e) {
      print('Error creating appointment: $e');
    }
  }

  void selectDate(DateTime newDate) {
    currentSelectedDay = newDate;
    update();
  }
}
