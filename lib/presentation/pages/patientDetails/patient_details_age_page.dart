import 'dart:ui';

import 'package:docare/presentation/pages/patientDetails/patient_details_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets.gen.dart';
import '../auth/auth_controller.dart';

class PatientDetailsAgePage extends StatefulWidget {
  @override
  _PatientDetailsAgePageState createState() => _PatientDetailsAgePageState();
}

class _PatientDetailsAgePageState extends State<PatientDetailsAgePage> {
  final authController = Get.find<AuthController>();
  bool isChanged = false;
  final FocusNode phoneNumberFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientDetailsController>(
      init: PatientDetailsController(),
      builder: (patientDetailsController) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 16),
                  _patientDetailsTitleComponent(),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      _patientBirthDateTitleInfoComponent(),
                      SizedBox(height: 6),
                      _patientBirthDateDescriptionInfoComponent(),
                      _birthDatePickerComponent(patientDetailsController),
                    ],
                  ),
                  ListTile(
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Age ${DateTime.now().difference(patientDetailsController.birthDate).inDays ~/ 365.2}",
                          style: GoogleFonts.openSans(
                            color: isChanged ? Color(0xFF130B0B) : Color(0xFF858D9D),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.36,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 9),
                        Container(
                          width: 83,
                          height: 1,
                          decoration: ShapeDecoration(
                            color: isChanged ? Color(0xFF3BC090) : Color(0xFF5D6679),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  _continueButtonComponent(patientDetailsController),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container _birthDatePickerComponent(PatientDetailsController patientDetailsController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: Get.height * 0.4,
      child: CupertinoDatePicker(
        dateOrder: DatePickerDateOrder.ymd,

        minimumYear: 1900,

        //maximumYear: 2010,
        maximumDate: DateTime(
          DateTime.now().year - 18,
          DateTime.now().month,
          DateTime.now().day,
          10,
          20,
        ),
        backgroundColor: Colors.transparent,
        initialDateTime: patientDetailsController.birthDate,
        onDateTimeChanged: (DateTime newTime) {
          setState(() {
            patientDetailsController.birthDate = newTime;
            isChanged = true;
          });
        },
        mode: CupertinoDatePickerMode.date,
      ),
    );
  }

  Padding _patientBirthDateDescriptionInfoComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'This can’t be changed later.',
        style: GoogleFonts.openSans(
          color: Color(0xFF5D6679),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Padding _patientBirthDateTitleInfoComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        "What’s your date of birth?",
        style: GoogleFonts.openSans(
          color: Color(0xFF090F47),
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _patientDetailsTitleComponent() {
    return Padding(
      padding: const EdgeInsets.only(right: 0, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset(
              Assets.icons.leftArrow.path,
            ),
          ),
          Text(
            " Patient Details",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Color _continueButtonColor(PatientDetailsController patientDetailsController) {
    return (patientDetailsController.textEditingNameController.text.isNotEmpty &&
            (authController.currentPhoneNumber.phoneNumber != null &&
                authController.currentPhoneNumber.phoneNumber!.isNotEmpty))
        ? Color(0xFF33CE95)
        : Color(0x6D53C298);
  }

  Widget _continueButtonComponent(PatientDetailsController patientDetailsController) {
    return GestureDetector(
      onTap: () {
        _showConfirmationDialog(
          context,
          (DateTime.now().difference(patientDetailsController.birthDate).inDays ~/ 365.2),
          patientDetailsController,
        );
      },
      child: Container(
        width: Get.width,
        height: 49,
        margin: EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: _continueButtonColor(patientDetailsController),
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
    );
  }

  void _showConfirmationDialog(BuildContext context, int age, PatientDetailsController patientDetailsController) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0xff121212).withOpacity(0.05),
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 12),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You’re $age?',
                      style: GoogleFonts.openSans(
                        color: Color(0xFF130B0B),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.36,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Make sure this is your correct age as you can’t change this later.',
                      style: GoogleFonts.openSans(
                        color: Color(0xFF130B0B),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Color(0xFF100C08),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Get.back();

                            await patientDetailsController.updateUserData();
                            Future.delayed(Duration(milliseconds: 100), () {
                              Get.back();
                            });
                            Get.back();
                          },
                          child: Text(
                            'Confirm',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Color(0xFF3BC090),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ],
        );
      },
    );
  }
}
