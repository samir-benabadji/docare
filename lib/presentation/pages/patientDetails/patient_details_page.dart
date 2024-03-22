import 'package:docare/presentation/pages/patientDetails/patient_details_age_page.dart';
import 'package:docare/presentation/pages/patientDetails/patient_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../core/assets.gen.dart';
import '../auth/auth_controller.dart';

class PatientDetailsPage extends StatefulWidget {
  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  final authController = Get.find<AuthController>();
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
                  _nameTextFieldComponent(patientDetailsController),
                  SizedBox(height: 16),
                  _phoneNumberTextFieldComponent(),
                  SizedBox(height: 16),
                  _genderDropDownMenuButtonComponent(patientDetailsController),
                  SizedBox(height: 24),
                  _continueButtonComponent(patientDetailsController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _genderDropDownMenuButtonComponent(PatientDetailsController patientDetailsController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 12.28,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: patientDetailsController.gender,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide(
                  color: Color(0xFF5D6679),
                  width: 1.0,
                ),
              ),
            ),
            hint: Text(
              'Gender',
              style: GoogleFonts.poppins(
                color: Color(0xFFAFB2B9),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                patientDetailsController.gender = newValue;
              });
            },
            items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
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

  Widget _nameTextFieldComponent(PatientDetailsController patientDetailsController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Name',
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 12.28,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: patientDetailsController.textEditingNameController,
            decoration: InputDecoration(
              hintText: 'Full Name',
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

  Widget _phoneNumberTextFieldComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone Number',
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 12.28,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color(0xFF5D6679),
                  ),
                ),
              ),
              child: InternationalPhoneNumberInput(
                initialValue: authController.defaultCountryPhone,
                onInputChanged: (PhoneNumber number) {
                  authController.currentPhoneNumber = number;
                  authController.isValidNumber = number.dialCode != number.phoneNumber;
                  authController.update();
                },
                onSaved: (PhoneNumber number) {
                  authController.currentPhoneNumber = number;
                  authController.update();
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                spaceBetweenSelectorAndTextField: 0,
                ignoreBlank: false,
                focusNode: phoneNumberFocusNode,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.grey),
                textFieldController: authController.textEditingPhoneController,
                formatInput: false,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                cursorColor: Colors.black,
                textStyle: GoogleFonts.openSans(
                  color: Color(0xFF100C08),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.30,
                ),
                inputDecoration: InputDecoration(
                  errorStyle: GoogleFonts.openSans(
                    color: Color(0xFFF04437),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 10, left: 0),
                  border: InputBorder.none,
                  hintText: 'Phone number',
                  hintStyle: GoogleFonts.openSans(
                    color: Color(0xFF858D9D),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          if (authController.verificationFailedWithPhone != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                width: double.infinity,
                child: Text(
                  authController.verificationFailedWithPhone!,
                  style: GoogleFonts.openSans(
                    textStyle: GoogleFonts.openSans(
                      color: Color(0xFFF04437),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
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
        if ((patientDetailsController.textEditingNameController.text.isNotEmpty &&
            (authController.currentPhoneNumber.phoneNumber != null &&
                authController.currentPhoneNumber.phoneNumber!.isNotEmpty))) Get.to(() => PatientDetailsAgePage());
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
}
