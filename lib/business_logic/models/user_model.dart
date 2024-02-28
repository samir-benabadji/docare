import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final int userType; // 1 for doctors, 2 for users, 3 for admins
  final String name;
  final String status;
  final String symptoms;
  final String profileImageUrl;
  final Map<String, List<Map<String, dynamic>>>?
      workingHours; // Working hours for each day (key: day name, value:(key: "start at" / "end at", value: hour of work))

  UserModel({
    required this.uid,
    required this.email,
    required this.userType,
    required this.name,
    required this.status,
    required this.symptoms,
    required this.profileImageUrl,
    this.workingHours,
  }) : assert(userType == 1 || workingHours == null, "Only doctors can have working hours.");

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      userType: data['userType'] ?? 2, // Default to regular user
      name: data['name'] ?? '',
      status: data['status'] ?? 'INCOMPLETE', // Default status is INCOMPLETE
      symptoms: data['symptoms'] ?? '', // Default symptoms is empty string when creating an account
      profileImageUrl: data['profileImageUrl'] ?? '',
      workingHours: (data['workingHours'] as Map<String, dynamic>?)?.map((key, value) {
        return MapEntry(key, List<Map<String, dynamic>>.from(value));
      }),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'userType': userType,
      'name': name,
      'status': status,
      'symptoms': symptoms,
      'profileImageUrl': profileImageUrl,
      'workingHours': workingHours,
    };
  }
}
