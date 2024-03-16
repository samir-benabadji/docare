import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String patientId;
  final String doctorId;
  final String optionPicked;
  final String startAt;
  final String endAt;

  Appointment({
    required this.patientId,
    required this.doctorId,
    required this.optionPicked,
    required this.startAt,
    required this.endAt,
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Appointment(
      patientId: data['patientId'],
      doctorId: data['doctorId'],
      optionPicked: data['optionPicked'],
      startAt: data['startAt'],
      endAt: data['endAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'optionPicked': optionPicked,
      'startAt': startAt,
      'endAt': endAt,
    };
  }
}
