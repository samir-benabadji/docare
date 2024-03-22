import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final int userType; // 1 for doctors, 2 for patients, 0 for admins
  String? name;
  String? status;
  List<String>? symptoms;
  String? profileImageUrl;
  String? medicalSpeciality;
  String? addressLocation;
  String? phoneNumber;
  List<String>? favoriteDoctors;
  String? phoneNumberDialCode;
  List<Map<String, dynamic>>? options;
  Map<String, List<Map<String, dynamic>>>?
      workingHours; // Working hours for each day (key: timestamp, value:(key: "start at" / "end at", value: hour of work))
  Timestamp? createdAt;
  Timestamp? birthDate;
  String? gender;

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
    this.favoriteDoctors,
    this.phoneNumberDialCode,
    this.options,
    this.workingHours,
    this.createdAt,
    this.birthDate,
    this.gender,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    List<String> symptoms = [];
    if (data['symptoms'] != null) {
      if (data['symptoms'] is List) {
        symptoms = List<String>.from(data['symptoms']);
      } else {
        symptoms = [data['symptoms']];
      }
    }

    List<Map<String, dynamic>>? options;
    if (data['options'] != null) {
      options = List<Map<String, dynamic>>.from(
        data['options'].map(
          (option) => {'name': option['name'], 'price': option['price']},
        ),
      );
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
      favoriteDoctors: List<String>.from(data['favoriteDoctors'] ?? []),
      phoneNumberDialCode: data['phoneNumberDialCode'],
      options: options,
      workingHours: (data['workingHours'] as Map<String, dynamic>?)?.map((key, value) {
        return MapEntry(key, List<Map<String, dynamic>>.from(value));
      }),
      createdAt: data['createdAt'],
      birthDate: data['birthDate'],
      gender: data['gender'],
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
      'favoriteDoctors': favoriteDoctors,
      'phoneNumberDialCode': phoneNumberDialCode,
      'options': options?.map((option) => {'name': option['name'], 'price': option['price']}).toList(),
      'workingHours': workingHours,
      'createdAt': createdAt,
      'birthDate': birthDate,
      'gender': gender,
    };
  }
}
