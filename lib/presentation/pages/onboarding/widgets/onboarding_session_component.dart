import 'package:docare/core/constants/theme.dart';
import 'package:docare/presentation/pages/onboarding/onboarding_session_option_association_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../business_logic/models/session_model.dart';
import '../../../../core/assets.gen.dart';
import '../onboarding_controller.dart';

class SessionComponent extends StatefulWidget {
  SessionModel session;
  final int sessionIndex;
  SessionComponent({super.key, required this.session, required this.sessionIndex});

  @override
  State<SessionComponent> createState() => _SessionComponentState();
}

class _SessionComponentState extends State<SessionComponent> {
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
    return GetBuilder<OnboardingController>(
      initState: (state) {},
      builder: (onboardingController) {
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
                                onboardingController.isSavedSuccessfully = false;
                                onboardingController.update();
                                SessionModel? sessionToUpdate = onboardingController.allSessions.firstWhereOrNull(
                                  (session) => session.id == widget.session.id,
                                );
                                if (sessionToUpdate != null) {
                                  sessionToUpdate.startAt = startsAt;
                                  onboardingController.update();
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
                                    ? onboardingController.formatTimeOfDay(widget.session.startAt!)
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
                                onboardingController.isSavedSuccessfully = false;
                                onboardingController.update();
                                SessionModel? sessionToUpdate = onboardingController.allSessions.firstWhereOrNull(
                                  (session) => session.id == widget.session.id,
                                );
                                if (sessionToUpdate != null) {
                                  sessionToUpdate.endAt = endsAt;
                                  onboardingController.update();
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
                                    ? onboardingController.formatTimeOfDay(widget.session.endAt!)
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
                      onboardingController.deleteSessionById(widget.session.id);
                    },
                    child: Image.asset(
                      Assets.icons.trashCan.path,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 24,
                  child: GestureDetector(
                    onTap: () async {
                      String? associatedSessionOption = await Get.to(() => OnboardingSessionOptionAssociationPage());
                      if (associatedSessionOption != null) {
                        SessionModel? sessionToUpdate = onboardingController.allSessions.firstWhereOrNull(
                          (session) => session.id == widget.session.id,
                        );
                        if (sessionToUpdate != null) {
                          sessionToUpdate.sessionOption = associatedSessionOption;
                          onboardingController.update();
                        }
                      }
                    },
                    child: Image.asset(
                      Assets.icons.syringe.path,
                      width: 30,
                      height: 30,
                      color: widget.session.sessionOption != null ? DocareTheme.apple : null,
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
