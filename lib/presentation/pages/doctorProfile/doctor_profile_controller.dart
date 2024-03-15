import 'package:get/get.dart';

class DoctorProfileController extends GetxController {
  DateTime currentSelectedMonth = DateTime.now();
  DateTime currentSelectedDay = DateTime.now();
  String currentSelectedSessionStartAt = "";

  List<String> doctorExtraInformations = ["Appoitement", "Equiquement", "Clinic"];
  String currentSelectedDoctorExtraInformation = "";

  DateTime get selectedDate => currentSelectedMonth;
  DateTime get highlightedDate => currentSelectedDay;

  void previousMonth() {
    currentSelectedMonth = DateTime(currentSelectedMonth.year, currentSelectedMonth.month - 1, 1);
    update();
  }

  void nextMonth() {
    currentSelectedMonth = DateTime(currentSelectedMonth.year, currentSelectedMonth.month + 1, 1);
    update();
  }

  void selectDate(DateTime newDate) {
    currentSelectedDay = newDate;
    update();
  }
}
