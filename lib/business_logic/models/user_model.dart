import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final int userType; // 1 for doctors, 2 for users, 3 for admins
  final String username;
  final String status; 

  UserModel({
    required this.uid,
    required this.email,
    required this.userType,
    required this.username,
    required this.status,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      userType: data['userType'] ?? 2, // Default to regular user
      username: data['username'] ?? '',
      status: data['status'] ?? 'INCOMPLETE', // Default status is INCOMPLETE
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'userType': userType,
      'username': username,
      'status': status,
    };
  }
}
