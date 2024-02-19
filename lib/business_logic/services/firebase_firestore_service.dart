import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add or update user data
  Future<void> addUser(String uid, String email, int userType) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'userType': userType,
      }, SetOptions(merge: true)); // Merge true to update data if exists
    } catch (e) {
      print('Error adding user to Firestore: $e');
      // Handle exceptions
    }
  }

  // Method to fetch user data by uid
  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching user from Firestore: $e');
      // Handle exceptions
    }
    return null;
  }

  // Example method to update user data - can be extended for other fields
  Future<void> updateUserType(String uid, int userType) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'userType': userType,
      });
    } catch (e) {
      print('Error updating user in Firestore: $e');
      // Handle exceptions
    }
  }

  // Example method to delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting user from Firestore: $e');
      // Handle exceptions
    }
  }
}
