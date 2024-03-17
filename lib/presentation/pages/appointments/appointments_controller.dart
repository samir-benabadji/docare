import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../business_logic/models/appointment_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../widgets/utils.dart';

class AppointmentsController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
  final BehaviorSubject<List<AppointmentModel>> appointmentsStream = BehaviorSubject();

  String appointmentCategory = "Upcoming";

  @override
  void onInit() {
    super.onInit();
    getPatientAppointments();
  }

  @override
  void onClose() {
    appointmentsStream.close();
    super.onClose();
  }

  Future<void> getPatientAppointments() async {
    if (_firebaseFirestoreService.getUserModel == null) {
      showToast("User's information is not available.");
      return;
    }
    if (_firebaseFirestoreService.getUserModel!.userType != 2) return;
    try {
      // Fetching appointments for the current patient
      final List<AppointmentModel> appointments =
          await _firebaseFirestoreService.getAppointmentsForPatient(_firebaseFirestoreService.getUserModel!.uid);
      // Updating the appointments stream with the fetched appointments
      appointmentsStream.add(appointments);
    } catch (e) {
      // TODO: Handle errors
      print('Error fetching appointments: $e');
    }
  }
}
