import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../business_logic/models/appointment_model.dart';
import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../widgets/utils.dart';

class AppointmentsController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
  final BehaviorSubject<List<AppointmentModel>> appointmentsStream = BehaviorSubject();
  final BehaviorSubject<List<AppointmentModel>> canceledAppointmentsStream = BehaviorSubject();
  final BehaviorSubject<List<AppointmentModel>> pendingAppointmentsStream = BehaviorSubject();

  final BehaviorSubject<UserModel?> doctorUserModelStream = BehaviorSubject();
  final BehaviorSubject<UserModel?> patientUserModelStream = BehaviorSubject();

  String appointmentCategory = "Upcoming";

  @override
  void onInit() {
    super.onInit();
    if (_firebaseFirestoreService.getUserModel != null) {
      _firebaseFirestoreService.getUserModel!.userType == 2 ? getPatientAppointments() : getDoctorAppointments();
    }
  }

  @override
  void onClose() {
    appointmentsStream.close();
    doctorUserModelStream.close();
    patientUserModelStream.close();
    canceledAppointmentsStream.close();
    pendingAppointmentsStream.close();
    super.onClose();
  }

  Future<void> getDoctorUserModel(String doctorUid) async {
    try {
      final UserModel? doctorUserModel = await _firebaseFirestoreService.getDoctorByUid(doctorUid);
      doctorUserModelStream.add(doctorUserModel);
    } catch (e) {
      // TODO: Handle errors
      print('Error fetching doctor user model: $e');
    }
  }

  Future<void> getPatientUserModel(String patientUid) async {
    try {
      final UserModel? patientUserModel = await _firebaseFirestoreService.getPatientByUid(patientUid);
      patientUserModelStream.add(patientUserModel);
    } catch (e) {
      // TODO: Handle errors
      print('Error fetching patient user model: $e');
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    bool? success = await _firebaseFirestoreService.cancelAppointment(appointmentId);
    if (success != null && success) {
      showToast('Appointment canceled successfully.');
    } else {
      showToast('Failed to cancel appointment. Please try again later.');
    }
    if (_firebaseFirestoreService.getUserModel != null) {
      _firebaseFirestoreService.getUserModel!.userType == 2 ? getPatientAppointments() : getDoctorAppointments();
    }
    Get.back();
  }

  Future<void> confirmAppointment(String appointmentId) async {
    bool? success = await _firebaseFirestoreService.confirmAppointment(appointmentId);
    if (success != null && success) {
      showToast('Appointment confirmed successfully.');
    } else {
      showToast('Failed to confirm appointment. Please try again later.');
    }
    if (_firebaseFirestoreService.getUserModel != null) {
      if (_firebaseFirestoreService.getUserModel!.userType == 1) getDoctorPendingAppointments();
    }
    Get.back();
  }

  Future<void> rejectAppointment(String appointmentId) async {
    bool? success = await _firebaseFirestoreService.rejectAppointment(appointmentId);
    if (success != null && success) {
      showToast('Appointment rejected successfully.');
    } else {
      showToast('Failed to reject appointment. Please try again later.');
    }
    if (_firebaseFirestoreService.getUserModel != null) {
      if (_firebaseFirestoreService.getUserModel!.userType == 1) getDoctorPendingAppointments();
    }
    Get.back();
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

  Future<void> getDoctorAppointments() async {
    try {
      // Fetching appointments for the doctor
      final List<AppointmentModel> appointments =
          await _firebaseFirestoreService.getAppointmentsForDoctor(_firebaseFirestoreService.getUserModel!.uid);
      // Updating the appointments stream with the fetched appointments
      appointmentsStream.add(appointments);
    } catch (e) {
      // TODO: Handle errors
      print('Error fetching doctor appointments: $e');
    }
  }

  Future<void> getDoctorCanceledAppointments() async {
    try {
      // Fetching appointments for the doctor
      final List<AppointmentModel> appointments =
          await _firebaseFirestoreService.getAppointmentsForDoctor(_firebaseFirestoreService.getUserModel!.uid);
      // Filtering out canceled appointments
      final List<AppointmentModel> canceledAppointments =
          appointments.where((appointment) => appointment.appointmentStatus == "CANCELED").toList();
      // Updating the appointments stream with the canceled appointments
      canceledAppointmentsStream.add(canceledAppointments);
    } catch (e) {
      // TODO: Handle errors
      print('Error fetching doctor appointments: $e');
    }
  }

  Future<void> getDoctorPendingAppointments() async {
    try {
      // Fetching appointments for the doctor
      final List<AppointmentModel> appointments =
          await _firebaseFirestoreService.getAppointmentsForDoctor(_firebaseFirestoreService.getUserModel!.uid);
      // Filtering out canceled appointments
      final List<AppointmentModel> pendingAppointments =
          appointments.where((appointment) => appointment.appointmentStatus == "PENDING").toList();
      // Updating the appointments stream with the canceled appointments
      pendingAppointmentsStream.add(pendingAppointments);
    } catch (e) {
      // TODO: Handle errors
      print('Error fetching doctor appointments: $e');
    }
  }

  List<AppointmentModel> filteringDataLogic(List<AppointmentModel> appointments, String appointmentCategory) {
    if (_firebaseFirestoreService.getUserModel != null) {
      return _firebaseFirestoreService.getUserModel!.userType == 2
          ? filteringLogicForPatient(appointments, appointmentCategory)
          : filteringLogicForDoctor(appointments, appointmentCategory);
    } else
      return [];
  }

  List<AppointmentModel> filteringLogicForPatient(List<AppointmentModel> appointments, String appointmentCategory) {
    return appointments.where((appointment) {
      if (appointmentCategory == "Upcoming") {
        return appointment.appointmentStatus == "UPCOMING";
      } else {
        return appointment.appointmentStatus == "PENDING";
      }
    }).toList();
  }

  List<AppointmentModel> filteringLogicForDoctor(List<AppointmentModel> appointments, String appointmentCategory) {
    final today = DateTime.now();
    if (appointmentCategory == "Upcoming") {
      return appointments.where((appointment) {
        final appointmentDate = DateTime.fromMillisecondsSinceEpoch(appointment.appointmentTimeStamp);
        return (appointmentDate.isAfter(today) || appointmentDate.isAtSameMomentAs(today)) &&
            appointment.appointmentStatus == "UPCOMING";
      }).toList();
    } else if (appointmentCategory == "History") {
      return appointments.where((appointment) {
        final appointmentDate = DateTime.fromMillisecondsSinceEpoch(appointment.appointmentTimeStamp);
        return appointmentDate.isBefore(today);
      }).toList();
    }
    return [];
  }
}
