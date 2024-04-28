import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../presentation/pages/doctorProfile/widgets/appointment_created_successfully_component.dart';
import '../../presentation/widgets/utils.dart';
import '../models/appointment_model.dart';
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
  UserModel? get getUserModel => _userModel.value;

  // Setter
  set setUserModel(UserModel value) {
    _userModel.value = value;
  }

  Future<UserModel?> getDoctorByUid(String doctorUid) async {
    try {
      final DocumentSnapshot docSnapshot = await _firebaseFirestore.collection('doctors').doc(doctorUid).get();
      if (docSnapshot.exists) {
        return UserModel.fromFirestore(docSnapshot);
      } else {
        print("Doctor not found with UID: $doctorUid");
        showToast('Doctor not found. Please verify the UID and try again.');
        return null;
      }
    } catch (e) {
      print('Error fetching doctor by UID: $e');
      showToast('Failed to fetch doctor. Please try again later.');
      return null;
    }
  }

  Future<UserModel?> getPatientByUid(String patientUid) async {
    try {
      final DocumentSnapshot docSnapshot = await _firebaseFirestore.collection('patients').doc(patientUid).get();
      if (docSnapshot.exists) {
        return UserModel.fromFirestore(docSnapshot);
      } else {
        print("Patient not found with UID: $patientUid");
        showToast('Patient not found. Please verify the UID and try again.');
        return null;
      }
    } catch (e) {
      print('Error fetching patient by UID: $e');
      showToast('Failed to fetch patient. Please try again later.');
      return null;
    }
  }

  Future<List<AppointmentModel>> getAppointmentsForPatient(String patientId) async {
    try {
      QuerySnapshot appointmentSnapshot =
          await _firebaseFirestore.collection('appointments').where('patientId', isEqualTo: patientId).get();

      List<AppointmentModel> appointments = appointmentSnapshot.docs.map((doc) {
        return AppointmentModel.fromFirestore(doc);
      }).toList();

      return appointments;
    } catch (e) {
      print('Error fetching appointments for patient: $e');
      showToast('Failed to get appointments. Please try again later.');
      return [];
    }
  }

  Future<List<AppointmentModel>> getAppointmentsForDoctor(String doctorId) async {
    try {
      QuerySnapshot appointmentSnapshot =
          await _firebaseFirestore.collection('appointments').where('doctorId', isEqualTo: doctorId).get();

      List<AppointmentModel> appointments = appointmentSnapshot.docs.map((doc) {
        return AppointmentModel.fromFirestore(doc);
      }).toList();

      return appointments;
    } catch (e) {
      print('Error fetching appointments for doctor: $e');
      showToast('Failed to get appointments. Please try again later.');
      return [];
    }
  }

  Future<void> checkAppointmentAvailability(AppointmentModel appointment) async {
    try {
      // Checking if the appointment already exists
      final QuerySnapshot appointmentsSnapshot = await _firebaseFirestore
          .collection('appointments')
          .where('doctorId', isEqualTo: appointment.doctorId)
          .where('startAt', isEqualTo: appointment.startAt)
          .limit(1) // Limiting to 1 to optimize query
          .get();

      if (appointmentsSnapshot.docs.isNotEmpty) {
        final appointmentData = appointmentsSnapshot.docs.first.data() as Map<String, dynamic>;
        final String patientId = appointmentData['patientId'];

        // Checking if the appointment is already taken
        if (patientId != appointment.patientId) {
          showToast('Sorry, this appointment is already taken.');
          return;
        }

        // Checking if the request is coming from the same user
        if (patientId == appointment.patientId) {
          showToast('You already made this appointment.');
          return;
        }
      }

      // available
      await addAppointment(appointment);
    } catch (e) {
      print('Error checking appointment availability: $e');
      showToast('Failed to check appointment availability. Please try again later.');
    }
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    try {
      await _firebaseFirestore.collection('appointments').add(appointment.toFirestore());
      Get.dialog(AppointmentCreatedSuccessfullyComponent());
    } catch (e) {
      print('Error adding appointment to Firestore: $e');
      showToast('Failed to create appointment. Please try again later.');
    }
  }

  Future<bool?> cancelAppointment(String appointmentId) async {
    try {
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('appointments').where('id', isEqualTo: appointmentId).get();

      if (querySnapshot.docs.isEmpty) {
        print('Appointment with ID $appointmentId not found.');
        showToast('Appointment was not found.');
        return null;
      }
      // Geting the reference to the document with the provided appointmentId
      DocumentReference appointmentRef = querySnapshot.docs.first.reference;

      // Updating the appointment status to "CANCELED"
      await appointmentRef.update({'appointmentStatus': 'CANCELED'});

      return true;
    } catch (e) {
      print('Error canceling appointment: $e');
      return false;
    }
  }

  Future<bool?> confirmAppointment(String appointmentId) async {
    try {
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('appointments').where('id', isEqualTo: appointmentId).get();

      if (querySnapshot.docs.isEmpty) {
        print('Appointment with ID $appointmentId not found.');
        showToast('Appointment was not found.');
        return null;
      }
      // Geting the reference to the document with the provided appointmentId
      DocumentReference appointmentRef = querySnapshot.docs.first.reference;

      // Updating the appointment status to "CANCELED"
      await appointmentRef.update({'appointmentStatus': 'UPCOMING'});

      return true;
    } catch (e) {
      print('Error confirming appointment: $e');
      return false;
    }
  }

  Future<bool?> rejectAppointment(String appointmentId) async {
    try {
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('appointments').where('id', isEqualTo: appointmentId).get();

      if (querySnapshot.docs.isEmpty) {
        print('Appointment with ID $appointmentId not found.');
        showToast('Appointment was not found.');
        return null;
      }
      // Geting the reference to the document with the provided appointmentId
      DocumentReference appointmentRef = querySnapshot.docs.first.reference;

      // Updating the appointment status to "CANCELED"
      await appointmentRef.update({'appointmentStatus': 'REJECTED'});

      return true;
    } catch (e) {
      print('Error rejecting appointment: $e');
      return false;
    }
  }

  Future<List<UserModel>> searchDoctorsByName(String name) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('doctors')
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThan: name + 'z')
          .get();

      List<UserModel> doctors = querySnapshot.docs.map((doc) {
        return UserModel.fromFirestore(doc);
      }).toList();

      return doctors;
    } catch (e) {
      print('Error searching doctors by name: $e');
      showToast('Failed to search doctors. Please try again later.');
      return [];
    }
  }

  Future<List<UserModel>> searchDoctorsBySpecialty(String specialty) async {
    try {
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('doctors').where('medicalSpeciality', isEqualTo: specialty).get();

      List<UserModel> doctors = querySnapshot.docs.map((doc) {
        return UserModel.fromFirestore(doc);
      }).toList();

      return doctors;
    } catch (e) {
      print('Error searching doctors by specialty: $e');
      showToast('Failed to search doctors. Please try again later.');
      return [];
    }
  }

  // Updating userModel's data whenever there is a change / trigger on the firestore collection
  void _updateUserModel(String docId) async {
    if (collectionPathFromUserType != null) {
      final UserModel? updatedUser = await getUserData(docId);
      if (updatedUser != null) {
        setUserModel = updatedUser;
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

  Future<bool> addOrUpdateUser(String uid, Map<String, dynamic> userData, {required bool isUpdatingUser}) async {
    try {
      String collectionPath = _getCollectionPathFromUserType(userData['userType']);
      Map<String, dynamic> dataToUpdate = {
        ...userData,
        if (isUpdatingUser) 'updatedAt': FieldValue.serverTimestamp() else 'createdAt': FieldValue.serverTimestamp(),
      };

      await _firebaseFirestore.collection(collectionPath).doc(uid).set(
            dataToUpdate,
            SetOptions(merge: true),
          );

      return true;
    } catch (e) {
      print('Error adding or updating user in Firestore: $e');
      // Handle exceptions
      return false;
    }
  }

  Future<bool> updateDoctorWorkingHours(String uid, Map<String, List<Map<String, dynamic>>> workingHours) async {
    try {
      // Getting the collection path based on the user type
      String collectionPath = _getCollectionPathFromUserType(getUserModel!.userType);

      // Updating the workingHours field of the doctor document
      await _firebaseFirestore.collection(collectionPath).doc(uid).update({'workingHours': workingHours});

      return true;
    } catch (e) {
      print('Error updating user working hours in Firestore: $e');
      // Handle exceptions
      return false;
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

  // getting all the near me doctors from firestore
  Stream<List<UserModel>> getNearMeDoctorsStream() async* {
    var status = await Permission.location.request();
    if (!status.isGranted) {
      print('User did not provide location permission');
      yield [];
      return;
    }

    // Get user's current location
    Position? currentPosition = await getCurrentUserPosition();
    if (currentPosition == null) {
      print('Failed to get user location');
      yield [];
      return;
    }

    double userLatitude = currentPosition.latitude;
    double userLongitude = currentPosition.longitude;

    // Stream doctors sorted by distance
    yield* _firebaseFirestore.collection(_getCollectionPathFromUserType(1)).snapshots().map((snapshot) {
      List<UserModel> doctors = snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();

      // Sorting doctors by distance
      doctors.sort((a, b) {
        double doctorALatitude = double.parse(a.locationLatLng!['latitude']!);
        double doctorALongitude = double.parse(a.locationLatLng!['longitude']!);
        double distanceA = calculateDistance(userLatitude, userLongitude, doctorALatitude, doctorALongitude);

        double doctorBLatitude = double.parse(b.locationLatLng!['latitude']!);
        double doctorBLongitude = double.parse(b.locationLatLng!['longitude']!);
        double distanceB = calculateDistance(userLatitude, userLongitude, doctorBLatitude, doctorBLongitude);

        return distanceA.compareTo(distanceB);
      });

      return doctors.reversed.toList();
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
