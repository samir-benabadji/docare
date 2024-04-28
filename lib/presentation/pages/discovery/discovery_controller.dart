import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../widgets/utils.dart';

class DiscoveryController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = FirebaseFirestoreService();
  final BehaviorSubject<List<UserModel>> topDoctorsStream = BehaviorSubject();
  final BehaviorSubject<List<UserModel>> nearMeDoctorsStream = BehaviorSubject();
  final BehaviorSubject<List<UserModel>> specialistDoctorsStream = BehaviorSubject();
  final BehaviorSubject<List<UserModel>> searchedDoctorsStream = BehaviorSubject();

  final TextEditingController textEditingSearchController = TextEditingController();
  String currentSelectedSpeciality = '';

  bool get showXButton => textEditingSearchController.text.isNotEmpty;

  late StreamSubscription<List<UserModel>>? _topDoctorsSubscription;

  @override
  void onReady() {
    loadDoctors();
    super.onReady();
  }

  void cancelTopDoctorsSubscription() {
    _topDoctorsSubscription?.cancel();
  }

  void loadDoctors() {
    _topDoctorsSubscription = _firebaseFirestoreService.getDoctorsStream().listen(
      (data) {
        topDoctorsStream.add(data);
      },
      onError: (error) {
        if (error is FirebaseException) {
          if (error.code == "permission-denied") {
            print('Permission Denied Error: ${error.message}');
            return;
          }
        }
        print("Error loading doctors: $error");
        showToast(
          Get.context != null
              ? AppLocalizations.of(Get.context!)!.failedToLoadDoctorsPleaseTryAgainLater
              : "Failed to load doctors. Please try again later.",
        );
      },
    );
  }

  void loadNearMeDoctors() {
    _topDoctorsSubscription = _firebaseFirestoreService.getNearMeDoctorsStream().listen(
      (data) {
        nearMeDoctorsStream.add(data);
      },
      onError: (error) {
        if (error is FirebaseException) {
          if (error.code == "permission-denied") {
            print('Permission Denied Error: ${error.message}');
            return;
          }
        }
        print("Error loading doctors: $error");
        showToast(
          Get.context != null
              ? AppLocalizations.of(Get.context!)!.failedToLoadDoctorsPleaseTryAgainLater
              : "Failed to load doctors. Please try again later.",
        );
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
        showToast(
          Get.context != null
              ? AppLocalizations.of(Get.context!)!.failedToSearchDoctorsByNamePleaseTryAgainLater
              : "Failed to search doctors by name. Please try again later.",
        );
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
      showToast(
        Get.context != null
            ? AppLocalizations.of(Get.context!)!.failedToLoadSpecialistDoctorsPleaseTryAgainLater
            : "Failed to load specialist doctors. Please try again later.",
      );
    }
  }

  @override
  void onClose() {
    cancelTopDoctorsSubscription();
    topDoctorsStream.close();
    specialistDoctorsStream.close();
    searchedDoctorsStream.close();
    nearMeDoctorsStream.close();
    super.onClose();
  }
}
