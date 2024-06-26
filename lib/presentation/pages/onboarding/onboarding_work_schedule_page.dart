import 'package:docare/core/constants/theme.dart';
import 'package:docare/presentation/pages/onboarding/widgets/onboarding_session_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../business_logic/models/session_model.dart';
import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_phone_number_page.dart';

class OnboardingWorkSchedulePage extends StatefulWidget {
  @override
  State<OnboardingWorkSchedulePage> createState() => _OnboardingWorkSchedulePageState();
}

class _OnboardingWorkSchedulePageState extends State<OnboardingWorkSchedulePage> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      initState: (state) {},
      builder: (onboardingController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _topBarComponent(onboardingController),
                SizedBox(height: 32),
                _titleComponent(),
                SizedBox(height: 64),
                _dayOfWeekComponent(onboardingController),
                SizedBox(height: 24),
                _sessionContentComponent(onboardingController),
                SizedBox(height: 16),
                if (onboardingController.isSavedSuccessfully) _continueButtonComponent(onboardingController),
                SizedBox(height: 32)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sessionContentComponent(OnboardingController onboardingController) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...onboardingController.allSessions
                .where((element) => element.timestamp == onboardingController.currentSelectedTimeStamp)
                .toList()
                .asMap()
                .entries
                .map((entry) {
              return Column(
                children: [
                  SessionComponent(
                    session: entry.value,
                    sessionIndex: entry.key,
                  ),
                  SizedBox(height: 28),
                ],
              );
            }).toList(),
            if (onboardingController.currentSelectedTimeStamp != 0) SizedBox(height: 22),
            if (onboardingController.currentSelectedTimeStamp != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      onboardingController.allSessions.add(
                        SessionModel(
                          id: Uuid().v4(),
                          timestamp: onboardingController.currentSelectedTimeStamp,
                        ),
                      );
                      onboardingController.isSavedSuccessfully = false;
                      onboardingController.update();
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
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.workDayText,
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                color: Color(0xFF090F47),
                fontSize: 18.13,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.34,
              ),
            ),
          ),
          SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _dayOfWeekComponent(OnboardingController onboardingController) {
    List<String> days = [
      AppLocalizations.of(context)!.sun,
      AppLocalizations.of(context)!.mon,
      AppLocalizations.of(context)!.tue,
      AppLocalizations.of(context)!.wed,
      AppLocalizations.of(context)!.thu,
      AppLocalizations.of(context)!.fri,
      AppLocalizations.of(context)!.sat,
    ];

    // Getting the index of the current day
    DateTime now = DateTime.now();
    int currentDayIndex = now.weekday - 1; // Adjusting index to start from 0

    // Moving the current day to the beginning of the list
    List<String> reorderedDays = [
      days[currentDayIndex],
      ...days.getRange(currentDayIndex + 1, days.length),
      ...days.getRange(0, currentDayIndex),
    ];

    // Getting the current date
    int currentDate = now.day;
    int currentMonth = now.month;
    int currentYear = now.year;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Container(
        padding: EdgeInsets.only(
          top: 9,
          bottom: 26,
          left: 15,
          right: 25,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: reorderedDays.asMap().entries.map((entry) {
            String day = entry.value;
            int index = entry.key;
            // Calculating the date for each day, considering month end
            int date = currentDate + index;
            if (date > DateTime(now.year, now.month + 1, 0).day) {
              date -= DateTime(now.year, now.month + 1, 0).day;
            }

            int timestamp = DateTime(currentYear, currentMonth, date).millisecondsSinceEpoch;

            return GestureDetector(
              onTap: () {
                int selectedDate = currentDate + index;
                if (selectedDate > DateTime(now.year, now.month + 1, 0).day) {
                  selectedDate -= DateTime(now.year, now.month + 1, 0).day;
                  currentMonth++;
                  if (currentMonth > 12) {
                    currentMonth = 1;
                    currentYear++;
                  }
                }

                onboardingController.currentSelectedTimeStamp = timestamp;

                onboardingController.update();
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '$day $date',
                      style: GoogleFonts.radioCanada(
                        color: Color(0xFF090F47),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.17,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: onboardingController.currentSelectedTimeStamp == timestamp
                            ? Color(0x7F058155)
                            : (onboardingController.allSessions.any(
                                      (element) => element.timestamp == timestamp,
                                    ) &&
                                    onboardingController.isSavedSuccessfully)
                                ? Color(0xFFEFC02D)
                                : Color(0x2B058155),
                        shape: BoxShape.circle,
                      ),
                      child: (onboardingController.allSessions.any(
                                (element) => element.timestamp == timestamp,
                              ) &&
                              onboardingController.isSavedSuccessfully)
                          ? SvgPicture.asset(
                              Assets.icons.check.path,
                              fit: BoxFit.scaleDown,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _topBarComponent(OnboardingController onboardingController) {
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
              onboardingController.onSaveClicked();
            },
            child: Text(
              AppLocalizations.of(context)!.saveText,
              style: GoogleFonts.montserrat(
                color: onboardingController.isSavedSuccessfully ? DocareTheme.babyStrawberry : DocareTheme.strawberry,
                fontSize: 15.65,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _continueButtonComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () {
        Get.to(() => OnboardingPhoneNumberPage());
      },
      child: Container(
        width: Get.width,
        height: 49,
        margin: EdgeInsets.symmetric(horizontal: 44),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: _continueButtonColor(),
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
          AppLocalizations.of(context)!.continueButtonText,
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 18.55,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.35,
          ),
        ),
      ),
    );
  }

  Color _continueButtonColor() {
    return DocareTheme.apple;
  }
}
