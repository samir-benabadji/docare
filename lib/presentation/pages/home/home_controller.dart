import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_auth_service.dart';
import '../../../core/assets.gen.dart';
import '../appointments/appointments_page.dart';
import '../discovery/discovery_page.dart';
import '../history/history_page.dart';
import '../patientProfile/patient_profile_page.dart';

class HomeController extends GetxController {
  final UserModel? userModel;

  HomeController({this.userModel});

  int currentIndex = 0;
  int previousIndex = 0;

  Widget get currentPage => socialPages[currentIndex].page;

  final socialPages = <CustomNavigator>[];

  @override
  void onInit() {
    initBotttomNav();
    super.onInit();
  }

  Future<void> logout() async {
    final _firebaseAuthService = Get.find<FirebaseAuthService>();
    await _firebaseAuthService.signOut();
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
        page: HistoryPage(),
        bottomNavIconPath: Assets.icons.bottomNavBar.history.path,
      ),
      CustomNavigator(
        page: PatientProfilePage(),
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
