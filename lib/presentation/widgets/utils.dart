import 'dart:math';

import 'package:docare/business_logic/services/firebase_firestore_service.dart';
import 'package:docare/presentation/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import '../../business_logic/models/user_model.dart';
import '../pages/home/home_page.dart';
import '../pages/onboarding/onboarding_medical_speciality.dart';
import '../pages/onboarding/onboarding_symptoms_page.dart';
import '../pages/welcome/welcome_page.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future getCurrentUserPosition() async {
  try {
    // Requesting permission to access the user's location
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // permission denied
      showToast("Location permission denied. Please enable location access in your device settings.");
      return null;
    }

    // Getting the user's current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  } catch (e) {
    print('Error getting user location: $e');
    showToast("Failed to get user location. Please try again later.");
    return null;
  }
}

double calculateDistance(double userLatitude, double userLongitude, double doctorLatitude, double doctorLongitude) {
  // Calculation of distance between two points using Haversine formula
  const double earthRadius = 6371.0; // in kilometers

  double latDistance = degreesToRadians(doctorLatitude - userLatitude);
  double lonDistance = degreesToRadians(doctorLongitude - userLongitude);

  double a = sin(latDistance / 2) * sin(latDistance / 2) +
      cos(degreesToRadians(userLatitude)) * cos(degreesToRadians(doctorLatitude)) * sin(lonDistance / 2) * sin(lonDistance / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

DateTime parseTime(String timeString) {
  // Splitting the time string to get hours and minutes
  List<String> timeParts = timeString.split(':');
  int hours = int.parse(timeParts[0]);
  int minutes = int.parse(timeParts[1].split(' ')[0]);

  // Creating a DateTime object with the parsed time
  return DateTime(1, 1, 1, hours, minutes);
}

void navigatingTheUserDependingOnHisStatus(UserModel user) {
  Get.find<FirebaseFirestoreService>().setUserModel = user;
  switch (user.status) {
    case 'INCOMPLETE':
      user.userType == 1
          ? Get.offAll(
              () => OnboardingMedicalSpecialityPage(
                userModel: user,
              ),
            )
          : Get.offAll(() => OnboardingSymptomsPage(userModel: user));
      break;
    case 'PENDING':
      break;
    case 'COMPLETED':
      Get.off(() => HomePage(userModel: user));
      break;
    case 'REJECTED':
      break;
    case 'BANNED':
    case 'DISABLED':
    case 'DELETED':
      Get.off(() => WelcomePage());
      break;
    default:
      Get.off(() => WelcomePage());
      break;
  }
}

String formatPhoneNumber(PhoneNumber phoneNumber) {
  if (phoneNumber.phoneNumber == null) return "Unknown";
  if (phoneNumber.phoneNumber!.isEmpty) return "Unknown";
  return '${phoneNumber.phoneNumber}';
}

String formatWorkingDays(Map<String, List<Map<String, dynamic>>> workingHours) {
  if (workingHours.isEmpty) return "Not specified";

  List<String> days = workingHours.keys.map((timestamp) {
    // Converting timestamp to DateTime to extract day name
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    String dayName = DateFormat('EEEE').format(dateTime); // Getting full day name
    // Extracting day number
    int dayNumber = dateTime.day;
    return '$dayName $dayNumber';
  }).toList();

  return days.join(', ');
}

String formatWorkingHoursOfDay(Map<String, List<Map<String, dynamic>>> workingHours, String day) {
  if (workingHours.isEmpty || !workingHours.containsKey(day)) return "Not specified";

  var daySchedule = workingHours[day]?.first;
  if (daySchedule == null) return "Closed";

  return "Start at ${daySchedule['start at']} and end at ${daySchedule['end at']}";
}

Widget shimmerComponent(double width, double height, {BorderRadius? borderRadius}) {
  return Container(
    width: width,
    height: height,
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius ??
                    BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

bool _isProgressShowing = false;
showProgress() {
  // if (_isProgressShowing) return;
  if (Get.focusScope!.hasFocus) Get.focusScope!.unfocus();
  Get.dialog(ProgressDialog(), barrierDismissible: false);
  _isProgressShowing = true;

  Future.delayed(Duration(seconds: 15), () {
    if (_isProgressShowing) {
      dismissProgress(); // Dismissing the progress dialog if it's still showing after 15 seconds
    }
  });
}

dismissProgress() {
  if (_isProgressShowing) {
    Get.back();
    _isProgressShowing = false;
  }
}
