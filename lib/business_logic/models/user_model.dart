import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final int userType; // 1 for doctors, 2 for users, 3 for admins

  UserModel({required this.uid, required this.email, required this.userType});

  // Convert Firestore document to AppUser
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      userType: data['userType'] ?? 2, // Default to regular user
    );
  }

  // Convert AppUser to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'userType': userType,
    };
  }
}
