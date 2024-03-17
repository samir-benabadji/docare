import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String patientId;
  final String doctorId;
  final Map<String, dynamic> optionPicked;
  final String startAt;
  final String endAt;
  final int appointmentTimeStamp;
  final Timestamp? createdAt;

  AppointmentModel({
    required this.patientId,
    required this.doctorId,
    required this.optionPicked,
    required this.startAt,
    required this.endAt,
    required this.appointmentTimeStamp,
    this.createdAt,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      patientId: data['patientId'],
      doctorId: data['doctorId'],
      optionPicked: data['optionPicked'],
      startAt: data['startAt'],
      endAt: data['endAt'],
      appointmentTimeStamp: data['appointmentTimeStamp'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'optionPicked': optionPicked,
      'startAt': startAt,
      'endAt': endAt,
      'appointmentTimeStamp': appointmentTimeStamp,
      'createdAt': createdAt,
    };
  }
}
