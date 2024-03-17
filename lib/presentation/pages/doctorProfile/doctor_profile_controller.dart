import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../business_logic/models/appointment_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../widgets/utils.dart';

class DoctorProfileController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();

  DateTime currentSelectedMonth = DateTime.now();
  DateTime currentSelectedDay = DateTime.now();
  String currentSelectedSessionStartAt = "";

  List<String> doctorExtraInformations = ["Appoitement", "Clinic"];
  String currentSelectedDoctorExtraInformation = "";

  Map<String, dynamic>? selectedOption;

  DateTime get selectedDate => currentSelectedMonth;
  DateTime get highlightedDate => currentSelectedDay;

  // Booking an appointment
  String startAtAppointment = '';
  String endAtAppointment = '';
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
    required String doctorId,
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

      final appointment = AppointmentModel(
        patientId: _firebaseFirestoreService.getUserModel!.uid,
        doctorId: doctorId,
        optionPicked: optionPicked,
        startAt: startAtAppointment,
        appointmentTimeStamp: timestamp!,
        endAt: endAtAppointment,
        createdAt: Timestamp.now(),
      );

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
