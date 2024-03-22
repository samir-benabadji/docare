import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docare/presentation/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'firebase_firestore_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get firebaseUserStream => _firebaseAuth.authStateChanges();
  User? get user => _firebaseAuth.currentUser;

  // Sign Up with email and password
  Future<String?> signUpWithEmailPassword(String email, String password, int userType) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        Map<String, dynamic> userData = {
          'email': email,
          'userType': userType,
          'status': 'INCOMPLETE',
          'createdAt': Timestamp.now(),
        };
        final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();

        await _firebaseFirestoreService.addOrUpdateUser(user.uid, userData, isUpdatingUser: false);
        return user.uid;
      }
      return null;
    } catch (e) {
      if (e is FirebaseAuthException) {
        showToast(_handleFirebaseAuthException(e));
      } else {
        showToast("An unknown error occurred.");
      }
      return null;
    }
  }

  // Sign In with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        showToast(_handleFirebaseAuthException(e));
      } else {
        showToast("An unknown error occurred.");
      }
      return null;
    }
  }

  // Handling FirebaseAuthException and returning a user-friendly message
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "Email address is invalid.";
      case 'user-disabled':
        return "This user has been disabled.";
      case 'user-not-found':
      case 'wrong-password':
        return "Incorrect email or password.";
      case 'weak-password':
        return "Password is too weak.";
      case 'email-already-in-use':
        return "Email is already in use by another account.";
      default:
        return "An error occurred, please try again later.";
    }
  }

  /* Future<void> refreshUserData() async {
  try {
    var currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
      int userType = ...;
      UserModel user = await _firebaseFirestoreService.getUserData(currentUser.uid, userType);
    }
  } catch (e) {
    print("Error refreshing user data: $e");
  }
}*/

  // Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
