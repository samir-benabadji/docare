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

  String selectedOption = "";

  DateTime get selectedDate => currentSelectedMonth;
  DateTime get highlightedDate => currentSelectedDay;

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
    required String optionPicked,
    required String startAt,
    required String endAt,
  }) async {
    try {
      if (_firebaseFirestoreService.getUserModel == null) return;
      if (_firebaseFirestoreService.getUserModel?.userType != 2) {
        showToast('Only patients can make appointments.');
        return;
      }

      final appointment = Appointment(
        patientId: _firebaseFirestoreService.getUserModel!.uid,
        doctorId: doctorId,
        optionPicked: optionPicked,
        startAt: startAt,
        endAt: endAt,
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
