import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../../core/assets.gen.dart';
import '../appointments/appointments_page.dart';
import '../discovery/discovery_page.dart';
import '../doctorProfile/doctor_profile_page.dart';
import '../doctorSchedule/doctor_schedule_page.dart';
import '../history/history_page.dart';
import '../patientProfile/patient_profile_page.dart';

class HomeController extends GetxController {
  int currentIndex = 0;
  int previousIndex = 0;

  Widget get currentPage => socialPages[currentIndex].page;

  final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();

  final socialPages = <CustomNavigator>[];

  @override
  void onInit() {
    initBotttomNav();
    super.onInit();
  }

  initBotttomNav() {
    socialPages.clear();
    socialPages.addAll([
      CustomNavigator(
        page: DiscoveryPage(),
        bottomNavIconPath: Assets.icons.bottomNavBar.discovery.path,
      ),
      CustomNavigator(
        page: AppointmentsPage(),
        bottomNavIconPath: Assets.icons.bottomNavBar.appointments.path,
      ),
      CustomNavigator(
        page: (_firebaseFirestoreService.getUserModel != null && _firebaseFirestoreService.getUserModel!.userType == 1)
            ? DoctorSchedulePage()
            : HistoryPage(),
        bottomNavIconPath:
            (_firebaseFirestoreService.getUserModel != null && _firebaseFirestoreService.getUserModel!.userType == 1)
                ? Assets.icons.bottomNavBar.schedule.path
                : Assets.icons.bottomNavBar.history.path,
      ),
      CustomNavigator(
        page: (_firebaseFirestoreService.getUserModel != null && _firebaseFirestoreService.getUserModel!.userType == 1)
            ? DoctorProfilePage(
                userModel: _firebaseFirestoreService.getUserModel!,
                showBackButton: false,
                showBookAppointmentButton: false,
              )
            : PatientProfilePage(),
        bottomNavIconPath: Assets.icons.bottomNavBar.profile.path,
      ),
    ]);
  }

  void onBottomNavTap(int newIndex) async {
    if (currentIndex != newIndex) {
      previousIndex = currentIndex;

      currentIndex = newIndex;
      update();
    }
  }
}

class CustomNavigator {
  final Widget page;
  final String bottomNavIconPath;
  final bool increaseSize;
  final BehaviorSubject<int>? stream;
  CustomNavigator({
    required this.page,
    required this.bottomNavIconPath,
    this.increaseSize = false,
    this.stream,
  });
}
