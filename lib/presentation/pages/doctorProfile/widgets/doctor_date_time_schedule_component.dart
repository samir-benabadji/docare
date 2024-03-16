import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../business_logic/models/user_model.dart';
import '../../../../core/assets.gen.dart';
import '../doctor_profile_controller.dart';

class DoctorDateTimeScheduleComponent extends StatelessWidget {
  final UserModel userModel;

  DoctorDateTimeScheduleComponent({required this.userModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorProfileController>(
      builder: (doctorProfileController) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              _currentSelectedMonthComponent(context),
              SizedBox(height: 30),
              _currentSelectedDayComponent(context),
              SizedBox(height: 22),
              _currentSelectedSessionComponent(context),
            ],
          ),
        );
      },
    );
  }

  Widget _currentSelectedSessionComponent(BuildContext context) {
    return GetBuilder<DoctorProfileController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildSessions(context, controller),
        );
      },
    );
  }

  Widget _currentSelectedDayComponent(BuildContext context) {
    return GetBuilder<DoctorProfileController>(
      builder: (controller) {
        return Row(
          children: _buildDays(context, controller),
        );
      },
    );
  }

  Widget _currentSelectedMonthComponent(BuildContext context) {
    return GetBuilder<DoctorProfileController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                Assets.icons.home.tinyLeftArrow.path,
              ),
              onPressed: controller.previousMonth,
            ),
            Text(
              DateFormat.yMMM().format(controller.selectedDate),
              style: GoogleFonts.roboto(
                color: Color(0xFF090F47),
                fontSize: 14.88,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                Assets.icons.home.tinyRightArrow.path,
              ),
              onPressed: controller.nextMonth,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildDays(BuildContext context, DoctorProfileController controller) {
    DateFormat dayFormat = DateFormat('E');
    DateFormat dateFormat = DateFormat('dd');
    DateTime startDate = controller.selectedDate.subtract(Duration(days: controller.selectedDate.weekday - 1));
    List<Widget> dayWidgets = [];

    for (int i = 0; i < 7; i++) {
      DateTime thisDay = startDate.add(Duration(days: i));
      bool isSelected = controller.highlightedDate.isAtSameMomentAs(thisDay);
      String dayName = dayFormat.format(thisDay);
      dayName = dayName[0].toUpperCase() + dayName.substring(1, 3).toLowerCase();
      String dateNumber = dateFormat.format(thisDay);

      dayWidgets.add(
        Expanded(
          child: GestureDetector(
            onTap: () => controller.selectDate(thisDay),
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Text(
                    dayName,
                    style: GoogleFonts.roboto(
                      color: isSelected ? Color(0xFF7ACDAF) : Color(0xFF090F47),
                      fontSize: 14.28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    dateNumber,
                    style: GoogleFonts.roboto(
                      color: isSelected ? Color(0xFF7ACDAF) : Colors.black.withOpacity(0.27000001072883606),
                      fontSize: 14.28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return dayWidgets;
  }

  List<Widget> _buildSessions(BuildContext context, DoctorProfileController doctorProfileController) {
    String selectedDay = DateFormat('E').format(doctorProfileController.highlightedDate).substring(0, 3).toLowerCase();
    selectedDay = selectedDay[0].toUpperCase() + selectedDay.substring(1);
    List<Map<String, dynamic>>? workingHours = userModel.workingHours?[selectedDay];
    List<Widget> sessionWidgets = [];

    if (workingHours != null && workingHours.isNotEmpty) {
      for (var session in workingHours) {
        String startAt = session['start at'].split(' ')[0];
        String endAt = session['end at'].split(' ')[0];

        sessionWidgets.add(
          GestureDetector(
            onTap: () {
              doctorProfileController.currentSelectedSessionStartAt = startAt;
              doctorProfileController.update();

              _appointmentConfirmationModalSheet(context, doctorProfileController, startAt, endAt);
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 17),
              decoration: ShapeDecoration(
                color: doctorProfileController.currentSelectedSessionStartAt == startAt
                    ? Color(0xFF7ACDAF)
                    : Color(0x5EC3C3C3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.11),
                ),
              ),
              child: Text(
                startAt,
                style: GoogleFonts.roboto(
                  color: doctorProfileController.currentSelectedSessionStartAt == startAt
                      ? Color(0xFFF9F6F4)
                      : Color(0xFF090F47),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      }
    } else {
      sessionWidgets.add(
        Text(
          'No sessions',
          style: GoogleFonts.roboto(
            color: Color(0xFF090F47),
            fontSize: 14.88,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return sessionWidgets;
  }

  Future<dynamic> _appointmentConfirmationModalSheet(
    BuildContext context,
    DoctorProfileController doctorProfileController,
    String startAt,
    String endAt,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pick the type of appointment:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  if (userModel.options != null)
                    Column(
                      children: userModel.options!.map((option) {
                        return RadioListTile(
                          title: Text(option['name']),
                          value: option,
                          groupValue: doctorProfileController.selectedOption,
                          onChanged: (value) {
                            setState(() {
                              doctorProfileController.selectedOption = value.toString();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (doctorProfileController.selectedOption.isNotEmpty) {
                        doctorProfileController.createAppointment(
                          startAt: startAt,
                          endAt: endAt,
                          doctorId: userModel.uid,
                          optionPicked: doctorProfileController.selectedOption,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Confirm', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
