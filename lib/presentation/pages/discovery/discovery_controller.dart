import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';

class DiscoveryController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = FirebaseFirestoreService();
  final BehaviorSubject<List<UserModel>> topDoctorsStream = BehaviorSubject();
  final BehaviorSubject<List<UserModel>> specialistDoctorsStream = BehaviorSubject();
  final BehaviorSubject<List<UserModel>> searchedDoctorsStream = BehaviorSubject();

  final TextEditingController textEditingSearchController = TextEditingController();
  String currentSelectedSpeciality = '';

  bool get showXButton => textEditingSearchController.text.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  void loadDoctors() {
    _firebaseFirestoreService.getDoctorsStream().listen(
      (data) {
        topDoctorsStream.add(data);
      },
      onError: (error) {
        print("Error loading doctors: $error");
        // TODO: Handle possible errors
      },
    );
  }

  Future<void> loadDoctorsByName() async {
    final name = textEditingSearchController.text.trim();
    if (name.isNotEmpty) {
      try {
        List<UserModel> data = await _firebaseFirestoreService.searchDoctorsByName(name);
        if (searchedDoctorsStream.isClosed == false) searchedDoctorsStream.add(data);
      } catch (e) {
        print("Error loading doctors by name: $e");
        // TODO: Handle possible errors
      }
      update();
    }
  }

  void clearSpecialistDoctorsStream() {
    if (specialistDoctorsStream.isClosed == false) specialistDoctorsStream.add([]);
  }

  void clearSearchedDoctorsStream() {
    if (searchedDoctorsStream.isClosed == false) searchedDoctorsStream.add([]);
  }

  Future<void> loadSpecialistDoctors(String specialty) async {
    try {
      List<UserModel> data = await _firebaseFirestoreService.searchDoctorsBySpecialty(specialty);
      if (specialistDoctorsStream.isClosed == false) specialistDoctorsStream.add(data);
    } catch (e) {
      print("Error loading specialist doctors: $e");
      // TODO: Handle possible errors
    }
  }

  @override
  void onClose() {
    topDoctorsStream.close();
    specialistDoctorsStream.close();
    searchedDoctorsStream.close();
    super.onClose();
  }
}
