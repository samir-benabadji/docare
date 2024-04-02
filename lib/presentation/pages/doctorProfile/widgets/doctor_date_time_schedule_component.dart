import 'package:docare/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../business_logic/models/user_model.dart';
import '../../../../business_logic/services/firebase_firestore_service.dart';
import '../../../../core/assets.gen.dart';
import '../../../widgets/utils.dart';
import '../../patientDetails/patient_details_page.dart';
import '../doctor_profile_controller.dart';

class DoctorDateTimeScheduleComponent extends StatelessWidget {
  final UserModel userModel;

  DoctorDateTimeScheduleComponent({required this.userModel});

  final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();

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
              SizedBox(height: 22),
              _bookAppointmentButtonComponent(context, doctorProfileController),
            ],
          ),
        );
      },
    );
  }

  Widget _patientProblemTextFieldComponent(DoctorProfileController doctorProfileController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            minLines: 3,
            maxLines: 3,
            controller: doctorProfileController.textEditingProblemController,
            decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(
                color: Color(0xFFAFB2B9),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              hintText: 'Describe your medical issue or concerns here',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide(
                  color: Color(0xFF5D6679),
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookAppointmentButtonComponent(BuildContext context, DoctorProfileController doctorProfileController) {
    return GestureDetector(
      onTap: () {
        if (_firebaseFirestoreService.getUserModel != null) {
          if (_firebaseFirestoreService.getUserModel?.phoneNumber == null ||
              _firebaseFirestoreService.getUserModel?.gender == null ||
              _firebaseFirestoreService.getUserModel?.birthDate == null) {
            Get.to(() => PatientDetailsPage());
            return;
          }
          _appointmentConfirmationOptionSelectionModalSheet(context, doctorProfileController);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: doctorProfileController.currentSelectedSessionStartAt.isNotEmpty
              ? DocareTheme.apple
              : DocareTheme.babyApple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.03),
          ),
        ),
        child: Text(
          'Book Appointment',
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
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
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _buildDays(context, controller),
          ),
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

    // Getting the total number of days in the selected month
    int totalDaysCount = DateTime(controller.selectedDate.year, controller.selectedDate.month + 1, 0).day;

    List<Widget> dayWidgets = [];

    // Getting today's date
    DateTime today = DateTime.now();

    for (int i = 1; i <= totalDaysCount; i++) {
      // Creating a DateTime object for each day of the month
      DateTime thisDay = DateTime(controller.selectedDate.year, controller.selectedDate.month, i);

      // Checking if this day is the highlighted date
      bool isSelected = controller.highlightedDate.year == thisDay.year &&
          controller.highlightedDate.month == thisDay.month &&
          controller.highlightedDate.day == thisDay.day;

      // Checking if this day is before today
      bool isPastDay = thisDay.isBefore(DateTime(today.year, today.month, today.day));

      // Getting the day name and date number
      String dayName = dayFormat.format(thisDay);
      dayName = dayName[0].toUpperCase() + dayName.substring(1, 3).toLowerCase();
      String dateNumber = dateFormat.format(thisDay);

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            // Only allowing selection if the day is not in the past
            if (!isPastDay) {
              controller.selectDate(thisDay);
            }
          },
          child: Container(
            margin: EdgeInsets.only(right: 22),
            color: Colors.transparent,
            child: Column(
              children: [
                Text(
                  dayName,
                  style: GoogleFonts.roboto(
                    color: isPastDay
                        ? Color(0xFF090F47)
                        : isSelected
                            ? Color(0xFF7ACDAF)
                            : Color(0xFF090F47),
                    fontSize: 14.28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  dateNumber,
                  style: GoogleFonts.roboto(
                    color: isPastDay
                        ? Colors.grey
                        : isSelected
                            ? Color(0xFF7ACDAF)
                            : Color(0xFF090F47),
                    fontSize: 14.28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return dayWidgets;
  }

  List<Widget> _buildSessions(BuildContext context, DoctorProfileController doctorProfileController) {
    // Getting the current selected day
    DateTime selectedDay = doctorProfileController.highlightedDate;
    int? foundTimestamp;
    // Getting the working hours for the selected day
    if (userModel.workingHours != null) {
      userModel.workingHours!.forEach((key, value) {
        // Converting the string timestamp to a DateTime object
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(key));

        // Comparing if the dateTime matches selectedDay
        if (dateTime.year == selectedDay.year &&
            dateTime.month == selectedDay.month &&
            dateTime.day == selectedDay.day) {
          foundTimestamp = int.parse(key);
        }
      });
    }
    List<Map<String, dynamic>>? workingHours = userModel.workingHours?[foundTimestamp.toString()];
    List<Widget> sessionWidgets = [];

    if (workingHours != null && workingHours.isNotEmpty) {
      for (var session in workingHours) {
        String startAt = session['start at'].split(' ')[0];
        String endAt = session['end at'].split(' ')[0];

        int? timestamp = foundTimestamp;

        // Checking if the session is for the selected day
        if (startAt.isNotEmpty) {
          sessionWidgets.add(
            GestureDetector(
              onTap: () {
                doctorProfileController.startAtAppointment = session['start at'];
                doctorProfileController.endAtAppointment = session['end at'];

                doctorProfileController.currentSelectedSessionStartAt = startAt;
                if (timestamp != null) {
                  doctorProfileController.timestamp = timestamp;
                  doctorProfileController.update();
                } else {
                  showToast('Doctor did not provide appointment date');
                }
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

  Future<dynamic> _appointmentConfirmationOptionSelectionModalSheet(
    BuildContext context,
    DoctorProfileController doctorProfileController,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(
                            Assets.icons.leftArrow.path,
                          ),
                        ),
                        SizedBox(width: 37),
                        Text(
                          'Select your option',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(
                            color: Color(0xFF2AD495),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.31,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  if (userModel.options != null)
                    Column(
                      children: userModel.options!.map((option) {
                        return CheckboxListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text(option['name'])),
                              Text(option['price'].toString() + " \$"),
                            ],
                          ),
                          value: doctorProfileController.sessionOption == option,
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                doctorProfileController.sessionOption = option;
                              } else {
                                doctorProfileController.sessionOption = null;
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _appointmentConfirmationPatientProblemModalSheet(context, doctorProfileController);
                    },
                    child: Container(
                      width: Get.width,
                      height: 49,
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: _continueButtonColor(doctorProfileController),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F494949),
                            blurRadius: 4.60,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 18.55,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _continueButtonColor(DoctorProfileController doctorProfileController) {
    return doctorProfileController.sessionOption != null ? Color(0xFF33CE95) : Color(0x6D53C298);
  }

  Color _confirmButtonColor(DoctorProfileController doctorProfileController) {
    return doctorProfileController.textEditingProblemController.text.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }

  Future<dynamic> _appointmentConfirmationPatientProblemModalSheet(
    BuildContext context,
    DoctorProfileController doctorProfileController,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(
                              Assets.icons.leftArrow.path,
                            ),
                          ),
                          SizedBox(width: 37),
                          Text(
                            'Write Down Your Problem',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rubik(
                              color: Color(0xFF2AD495),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.31,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _patientProblemTextFieldComponent(doctorProfileController),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        if (doctorProfileController.sessionOption != null) {
                          doctorProfileController.createAppointment(
                            doctorUserModel: userModel,
                            optionPicked: doctorProfileController.sessionOption!,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: Get.width,
                        height: 49,
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: _confirmButtonColor(doctorProfileController),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F494949),
                              blurRadius: 4.60,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 18.55,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
