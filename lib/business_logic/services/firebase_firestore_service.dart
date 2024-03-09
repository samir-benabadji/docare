import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addOrUpdateUser(String uid, Map<String, dynamic> userData) async {
    try {
      String collectionPath = _getCollectionPathFromUserType(userData['userType']);
      await _firebaseFirestore.collection(collectionPath).doc(uid).set(
            userData,
            SetOptions(merge: true),
          );
    } catch (e) {
      print('Error adding or updating user in Firestore: $e');
      // Handle exceptions
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    final List<String> collections = ['doctors', 'patients', 'admins'];
    for (String collection in collections) {
      final DocumentSnapshot docSnapshot = await _firebaseFirestore.collection(collection).doc(uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromFirestore(docSnapshot);
      }
    }
    print("User not found in any collection");
    return null; // Returning null if user is not found in any collection
  }

  Future<void> deleteUser(String uid, int userType) async {
    try {
      String collectionPath = _getCollectionPathFromUserType(userType);
      await _firebaseFirestore.collection(collectionPath).doc(uid).delete();
    } catch (e) {
      print('Error deleting user from Firestore: $e');
      // Handle exceptions
    }
  }

  // getting all doctors from firestore
  Stream<List<UserModel>> getDoctorsStream() {
    return _firebaseFirestore.collection(_getCollectionPathFromUserType(1)).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    });
  }

  String _getCollectionPathFromUserType(int userType) {
    switch (userType) {
      case 1:
        return 'doctors';
      case 2:
        return 'patients';
      case 0:
        return 'admins';
      default:
        return 'users';
    }
  }
}
