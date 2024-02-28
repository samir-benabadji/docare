import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addOrUpdateUser(String uid, Map<String, dynamic> userData) async {
    try {
      await _firebaseFirestore.collection('users').doc(uid).set(
            userData,
            SetOptions(merge: true),
          );
    } catch (e) {
      print('Error adding or updating user in Firestore: $e');
      // Handle exceptions
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final DocumentSnapshot docSnapshot = await _firebaseFirestore.collection('users').doc(uid).get();
      return UserModel.fromFirestore(docSnapshot);
    } catch (e) {
      print("Error fetching user data from Firestore: $e");
      rethrow;
    }
  }

  // method to delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _firebaseFirestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting user from Firestore: $e');
      // Handle exceptions
    }
  }
}
