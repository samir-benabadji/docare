import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final int userType; // 1 for doctors, 2 for users, 0 for admins
  String? name;
  String? status;
  String? symptoms;
  String? profileImageUrl;
  String? medicalSpeciality;
  String? addressLocation;
  String? phoneNumber;
  String? phoneNumberDialCode;
  List<String>? options;
  Map<String, List<Map<String, dynamic>>>? workingHours;

  UserModel({
    required this.uid,
    required this.email,
    required this.userType,
    this.name,
    this.status,
    this.symptoms,
    this.profileImageUrl,
    this.medicalSpeciality,
    this.addressLocation,
    this.phoneNumber,
    this.phoneNumberDialCode,
    this.options,
    this.workingHours,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    List<String> options = [];
    if (data['options'] != null) {
      options = List<String>.from(data['options']);
    }

    String symptoms = '';
    if (data['symptoms'] != null) {
      symptoms = data['symptoms'] is List ? data['symptoms'].join(', ') : data['symptoms'];
    }

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      userType: data['userType'] ?? 2,
      name: data['name'],
      status: data['status'],
      symptoms: symptoms,
      profileImageUrl: data['profileImageUrl'],
      medicalSpeciality: data['medicalSpeciality'],
      addressLocation: data['addressLocation'],
      phoneNumber: data['phoneNumber'],
      phoneNumberDialCode: data['phoneNumberDialCode'],
      options: options,
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
      'medicalSpeciality': medicalSpeciality,
      'addressLocation': addressLocation,
      'phoneNumber': phoneNumber,
      'phoneNumberDialCode': phoneNumberDialCode,
      'options': options,
      'workingHours': workingHours,
    };
  }
}
