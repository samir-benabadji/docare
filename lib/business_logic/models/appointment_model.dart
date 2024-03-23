import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorProfileImageUrl;
  final Map<String, dynamic> optionPicked;
  final String startAt;
  final String endAt;
  final int appointmentTimeStamp;
  final String patientProblem;
  final String appointmentStatus;
  final Timestamp? createdAt;

  AppointmentModel({
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorProfileImageUrl,
    required this.optionPicked,
    required this.startAt,
    required this.endAt,
    required this.appointmentTimeStamp,
    required this.patientProblem,
    required this.appointmentStatus,
    this.createdAt,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      patientId: data['patientId'],
      doctorId: data['doctorId'],
      doctorName: data['doctorName'],
      doctorSpecialty: data['doctorSpecialty'],
      doctorProfileImageUrl: data['doctorProfileImageUrl'],
      optionPicked: data['optionPicked'],
      startAt: data['startAt'],
      endAt: data['endAt'],
      appointmentTimeStamp: data['appointmentTimeStamp'],
      patientProblem: data['patientProblem'],
      appointmentStatus: data['appointmentStatus'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'doctorProfileImageUrl': doctorProfileImageUrl,
      'optionPicked': optionPicked,
      'startAt': startAt,
      'endAt': endAt,
      'appointmentTimeStamp': appointmentTimeStamp,
      'patientProblem': patientProblem,
      'appointmentStatus': appointmentStatus,
      'createdAt': createdAt,
    };
  }
}
