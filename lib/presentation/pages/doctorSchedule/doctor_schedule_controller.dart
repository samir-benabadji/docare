import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../business_logic/models/session_model.dart';
import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../../core/constants/theme.dart';

class DoctorScheduleController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
// Work Schedule
  int currentSelectedTimeStamp = 0;
  List<SessionModel> allSessions = [];
  Map<String, List<Map<String, dynamic>>>? workingHours;
  DateTime focusedDay = DateTime.now();
  DateTime currentDay = DateTime.now();

  bool isSavedSuccessfully = false;

  @override
  void onInit() {
    if (_firebaseFirestoreService.getUserModel != null) {
      workingHours = _firebaseFirestoreService.getUserModel?.workingHours;
      if (workingHours != null) allSessions = mapWorkingHoursToSessions(workingHours!);
      print(allSessions);
    }
    super.onInit();
  }

  Future<void> updateDoctorWorkingHours() async {
    try {
      UserModel? userModel = _firebaseFirestoreService.getUserModel;

      if (userModel != null) {
        workingHours = mapSessionsToWorkingHours(allSessions);

        if (workingHours != null && workingHours!.isNotEmpty)
          await _firebaseFirestoreService.updateDoctorWorkingHours(userModel.uid, workingHours!);
        Get.snackbar(
          'Success',
          'All sessions are updated successfully',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 5),
          backgroundColor: DocareTheme.apple,
          colorText: Colors.white,
        );
        isSavedSuccessfully = true;
        update();
      }
    } catch (e) {
      print('Error updating working hours: $e');
      // Handle exceptions
    }
  }

  void onSaveClicked() async {
    if (allSessions.isEmpty) {
      Get.snackbar(
        'No Sessions Added',
        'Please add at least one session to save your schedule',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
        backgroundColor: DocareTheme.tomato,
        colorText: Colors.white,
      );
      return;
    }

    // Checking if any session has null startAt or endAt
    bool hasIncompleteSessions = allSessions.any((session) => session.startAt == null || session.endAt == null);

    if (hasIncompleteSessions) {
      Get.snackbar(
        'Incomplete Sessions',
        'Please finish filling the sessions that you added',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
        backgroundColor: DocareTheme.tomato,
        colorText: Colors.white,
      );
      return;
    }

    // Checking for conflicts between session timings
    bool hasConflict = false;
    for (int i = 0; i < allSessions.length; i++) {
      for (int j = i + 1; j < allSessions.length; j++) {
        if (allSessions[i].timestamp == allSessions[j].timestamp) {
          DateTime startDateTimeI = DateTime(1, 1, 1, allSessions[i].startAt!.hour, allSessions[i].startAt!.minute);
          DateTime endDateTimeI = DateTime(1, 1, 1, allSessions[i].endAt!.hour, allSessions[i].endAt!.minute);
          DateTime startDateTimeJ = DateTime(1, 1, 1, allSessions[j].startAt!.hour, allSessions[j].startAt!.minute);
          DateTime endDateTimeJ = DateTime(1, 1, 1, allSessions[j].endAt!.hour, allSessions[j].endAt!.minute);

          if ((startDateTimeI.isBefore(endDateTimeJ) && endDateTimeI.isAfter(startDateTimeJ)) ||
              (startDateTimeJ.isBefore(endDateTimeI) && endDateTimeJ.isAfter(startDateTimeI))) {
            // Conflict
            hasConflict = true;
            break;
          }
        }
      }
      if (hasConflict) {
        break;
      }
    }

    if (hasConflict) {
      Get.snackbar(
        'Time Conflict',
        'Please fix the time conflicts between sessions',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
        backgroundColor: DocareTheme.tomato,
        colorText: Colors.white,
      );
      return;
    }

    await updateDoctorWorkingHours();
    update();
  }

  List<SessionModel> mapWorkingHoursToSessions(Map<String, List<Map<String, dynamic>>> workingHours) {
    List<SessionModel> sessions = [];

    workingHours.forEach((key, value) {
      final int timestamp = int.parse(key);
      value.forEach((workingHour) {
        final startAt = parseTimeOfDay(workingHour['start at']);
        final endAt = parseTimeOfDay(workingHour['end at']);

        sessions.add(
          SessionModel(
            id: workingHour['id'],
            timestamp: timestamp,
            startAt: startAt,
            endAt: endAt,
          ),
        );
      });
    });

    return sessions;
  }

  Map<String, List<Map<String, dynamic>>> mapSessionsToWorkingHours(List<SessionModel> sessions) {
    Map<String, List<Map<String, dynamic>>> mappedSessions = {};

    for (var session in sessions) {
      final timestamp = session.timestamp.toString();
      final start = formatTimeOfDay(session.startAt!);
      final end = formatTimeOfDay(session.endAt!);

      if (!mappedSessions.containsKey(timestamp)) {
        mappedSessions[timestamp] = [];
      }

      mappedSessions[timestamp]!.add({
        'start at': start,
        'end at': end,
        'id': session.id,
      });
    }

    return mappedSessions;
  }

  void deleteSessionById(String sessionId) async {
    allSessions.removeWhere((session) => session.id == sessionId);

    isSavedSuccessfully = false;
    update();
    await updateDoctorWorkingHours();
    update();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return "$hour:$minute ${time.period.name}";
  }

  TimeOfDay parseTimeOfDay(String formattedTime) {
    final parts = formattedTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1].substring(0, 2));
    final period = parts[1].substring(3);

    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  }
}
