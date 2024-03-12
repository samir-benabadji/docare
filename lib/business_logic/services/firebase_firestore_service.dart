import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String? _collectionPathFromUserType;
  final _userModel = Rx<UserModel?>(null);

  // Getter
  String? get collectionPathFromUserType => _collectionPathFromUserType;

  // Setter
  set collectionPathFromUserType(String? value) {
    _collectionPathFromUserType = value;
    // If the collection path is set, we start listening for changes
    if (_collectionPathFromUserType != null) {
      _startListeningForChanges();
    }
  }

  // Getter
  UserModel? get userModel => _userModel.value;

  // Setter
  set userModel(UserModel? value) {
    _userModel.value = value;
  }

  // Updating userModel's data whenever there is a change / trigger on the firestore collection
  void _updateUserModel(String docId) async {
    if (collectionPathFromUserType != null) {
      final UserModel? updatedUser = await getUserData(docId);
      if (updatedUser != null) {
        userModel = updatedUser;
      } else {
        print("User not found in Firestore.");
      }
    } else {
      print("Collection path is not set.");
    }
  }

  void _startListeningForChanges() {
    // Listening for changes
    _firebaseFirestore.collection(collectionPathFromUserType!).snapshots().listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.modified) {
          print('User data changed: ${change.doc.id}');
          _updateUserModel(change.doc.id);
        }
      });
    });
  }

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
    // If collectionPathFromUserType is not null, we use it directly
    if (collectionPathFromUserType != null) {
      final DocumentSnapshot docSnapshot =
          await _firebaseFirestore.collection(collectionPathFromUserType!).doc(uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromFirestore(docSnapshot);
      } else {
        print("User not found in collection: $collectionPathFromUserType");
        return null;
      }
    } else {
      // If collectionPathFromUserType is null, we iterate over collections
      final List<String> collections = ['doctors', 'patients', 'admins'];
      for (String collection in collections) {
        final DocumentSnapshot docSnapshot = await _firebaseFirestore.collection(collection).doc(uid).get();
        if (docSnapshot.exists) {
          collectionPathFromUserType = collection;
          return UserModel.fromFirestore(docSnapshot);
        }
      }
      print("User not found in any collection");
      return null; // Returning null if user is not found in any collection
    }
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

  Future<List<UserModel>> getDoctorsByIds(List<String> doctorIds) async {
    List<UserModel> doctors = [];
    try {
      for (String id in doctorIds) {
        final docSnapshot = await _firebaseFirestore.collection('doctors').doc(id).get();
        if (docSnapshot.exists) {
          doctors.add(UserModel.fromFirestore(docSnapshot));
        }
      }
    } catch (e) {
      print('Error fetching doctors by IDs: $e');
      // Handle exceptions
    }
    return doctors;
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
