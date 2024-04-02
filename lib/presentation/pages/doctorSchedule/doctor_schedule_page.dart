import 'package:docare/core/constants/theme.dart';
import 'package:docare/presentation/pages/doctorSchedule/widgets/doctor_schedule_session_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:uuid/uuid.dart';

import '../../../business_logic/models/session_model.dart';
import '../../../core/assets.gen.dart';
import 'doctor_schedule_controller.dart';

class DoctorSchedulePage extends StatefulWidget {
  @override
  State<DoctorSchedulePage> createState() => _DoctorSchedulePageState();
}

class _DoctorSchedulePageState extends State<DoctorSchedulePage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorScheduleController>(
      init: DoctorScheduleController(),
      initState: (state) {},
      builder: (doctorScheduleController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _topBarComponent(doctorScheduleController),
                SizedBox(height: 32),
                _titleComponent(),
                SizedBox(height: 64),
                _calendarComponent(doctorScheduleController),
                SizedBox(height: 24),
                _sessionContentComponent(doctorScheduleController),
                SizedBox(height: 16),
                SizedBox(height: 32)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _calendarComponent(DoctorScheduleController doctorScheduleController) {
    return TableCalendar(
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
      onDaySelected: (selectedDay, focusedDay) {
        doctorScheduleController.focusedDay = focusedDay;
        doctorScheduleController.currentDay = selectedDay;
        // Calculating the timestamp
        int timestamp = selectedDay.millisecondsSinceEpoch;

        // Updating the controller with the timestamp
        doctorScheduleController.currentSelectedTimeStamp = timestamp;
        doctorScheduleController.update();
      },
      currentDay: doctorScheduleController.currentDay,
      firstDay: DateTime.utc(2022),
      focusedDay: doctorScheduleController.focusedDay,
      lastDay: DateTime.utc(3000),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            date.day.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _sessionContentComponent(DoctorScheduleController doctorScheduleController) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...doctorScheduleController.allSessions
                .where((element) {
                  // Extracting year, month, and day from the session timestamp
                  DateTime sessionDate = DateTime.fromMillisecondsSinceEpoch(element.timestamp);
                  int sessionYear = sessionDate.year;
                  int sessionMonth = sessionDate.month;
                  int sessionDay = sessionDate.day;

                  // Extracting year, month, and day from the selected timestamp
                  DateTime selectedDate =
                      DateTime.fromMillisecondsSinceEpoch(doctorScheduleController.currentSelectedTimeStamp);
                  int selectedYear = selectedDate.year;
                  int selectedMonth = selectedDate.month;
                  int selectedDay = selectedDate.day;

                  // Comparing if they are the same year, month, and day
                  return sessionYear == selectedYear && sessionMonth == selectedMonth && sessionDay == selectedDay;
                })
                .toList()
                .asMap()
                .entries
                .map((entry) {
                  return Column(
                    children: [
                      DoctorScheduleSessionComponent(
                        session: entry.value,
                        sessionIndex: entry.key,
                      ),
                      SizedBox(height: 28),
                    ],
                  );
                })
                .toList(),
            if (doctorScheduleController.currentSelectedTimeStamp != 0) SizedBox(height: 22),
            if (doctorScheduleController.currentSelectedTimeStamp != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      doctorScheduleController.allSessions.add(
                        SessionModel(
                          id: Uuid().v4(),
                          timestamp: doctorScheduleController.currentSelectedTimeStamp,
                        ),
                      );
                      doctorScheduleController.isSavedSuccessfully = false;
                      doctorScheduleController.update();
                    },
                    child: Container(
                      width: 41,
                      height: 41,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFF0472),
                        shape: OvalBorder(),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _titleComponent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "Day of work",
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                color: Color(0xFF090F47),
                fontSize: 18.13,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.34,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBarComponent(DoctorScheduleController doctorScheduleController) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 14,
        left: 17,
        right: 26,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.icons.dOCARELogo.path,
          ),
          SizedBox(width: 2),
          SvgPicture.asset(
            Assets.icons.dOCAREText.path,
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              doctorScheduleController.onSaveClicked();
            },
            child: Text(
              'Save',
              style: GoogleFonts.montserrat(
                color:
                    doctorScheduleController.isSavedSuccessfully ? DocareTheme.babyStrawberry : DocareTheme.strawberry,
                fontSize: 15.65,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
