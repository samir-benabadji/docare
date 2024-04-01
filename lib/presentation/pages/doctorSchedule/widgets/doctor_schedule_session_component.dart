import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../business_logic/models/session_model.dart';
import '../../../../core/assets.gen.dart';
import '../doctor_schedule_controller.dart';

class DoctorScheduleSessionComponent extends StatefulWidget {
  SessionModel session;
  final int sessionIndex;
  DoctorScheduleSessionComponent({super.key, required this.session, required this.sessionIndex});

  @override
  State<DoctorScheduleSessionComponent> createState() => _DoctorScheduleSessionComponentState();
}

class _DoctorScheduleSessionComponentState extends State<DoctorScheduleSessionComponent> {
  Future<TimeOfDay?> _showTimePicker(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  String _ordinalSuffix(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return "$number" + "th";
    }
    switch (number % 10) {
      case 1:
        return "$number" + "st";
      case 2:
        return "$number" + "nd";
      case 3:
        return "$number" + "rd";
      default:
        return "$number" + "th";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorScheduleController>(
      initState: (state) {},
      builder: (doctorScheduleController) {
        return Column(
          children: [
            Text(
              "Time of the ${_ordinalSuffix(widget.sessionIndex + 1)} session",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Color(0xFF090F47),
                fontSize: 14.75,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.26,
              ),
            ),
            SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: Get.width,
                  height: 110,
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    shadows: [
                      BoxShadow(
                        color: Color(0xffD2D2D2).withOpacity(0.04),
                        blurRadius: 5.20,
                        offset: Offset(4, 5),
                        spreadRadius: -5,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 6),
                          Text(
                            "Starts",
                            style: GoogleFonts.radioCanada(
                              color: Color(0xFF090F47),
                              fontSize: 15.12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.27,
                            ),
                          ),
                          SizedBox(height: 36),
                          Text(
                            "Ends",
                            style: GoogleFonts.radioCanada(
                              color: Color(0xFF090F47),
                              fontSize: 15.12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.27,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 55),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              TimeOfDay? startsAt = await _showTimePicker(context);
                              if (startsAt != null) {
                                doctorScheduleController.isSavedSuccessfully = false;
                                doctorScheduleController.update();
                                SessionModel? sessionToUpdate = doctorScheduleController.allSessions.firstWhereOrNull(
                                  (session) => session.id == widget.session.id,
                                );
                                if (sessionToUpdate != null) {
                                  sessionToUpdate.startAt = startsAt;
                                  doctorScheduleController.update();
                                } else {}
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 31,
                              decoration: ShapeDecoration(
                                color: Color(0xC62AD495),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Text(
                                widget.session.startAt != null
                                    ? doctorScheduleController.formatTimeOfDay(widget.session.startAt!)
                                    : 'HH:MM PM',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ntr(
                                  color: Colors.white,
                                  fontSize: 15.12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.27,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 23),
                          GestureDetector(
                            onTap: () async {
                              TimeOfDay? endsAt = await _showTimePicker(context);
                              if (endsAt != null) {
                                doctorScheduleController.isSavedSuccessfully = false;
                                doctorScheduleController.update();
                                SessionModel? sessionToUpdate = doctorScheduleController.allSessions.firstWhereOrNull(
                                  (session) => session.id == widget.session.id,
                                );
                                if (sessionToUpdate != null) {
                                  sessionToUpdate.endAt = endsAt;
                                  doctorScheduleController.update();
                                } else {}
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 31,
                              decoration: ShapeDecoration(
                                color: Color(0xC62AD495),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Text(
                                widget.session.endAt != null
                                    ? doctorScheduleController.formatTimeOfDay(widget.session.endAt!)
                                    : 'HH:MM PM',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ntr(
                                  color: Colors.white,
                                  fontSize: 15.12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.27,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 28,
                  child: GestureDetector(
                    onTap: () {
                      doctorScheduleController.deleteSessionById(widget.session.id);
                    },
                    child: Image.asset(
                      Assets.icons.trashCan.path,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
