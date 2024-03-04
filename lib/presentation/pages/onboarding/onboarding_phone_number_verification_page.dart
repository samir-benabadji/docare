import 'dart:async';
import 'package:docare/presentation/pages/onboarding/onboarding_address_location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets.gen.dart';
import '../auth/auth_controller.dart';

class OnboardingPhoneNumberVerificationPage extends StatefulWidget {
  final bool testingAccount;
  OnboardingPhoneNumberVerificationPage({
    Key? key,
    this.testingAccount = false,
  }) : super(key: key);

  @override
  _OnboardingPhoneNumberVerificationPageState createState() => _OnboardingPhoneNumberVerificationPageState();
}

class _OnboardingPhoneNumberVerificationPageState extends State<OnboardingPhoneNumberVerificationPage> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  int _start = 60;

  void resend(AuthController verificationController) {
    if (!_isResendAgain) {
      setState(() {
        _isResendAgain = true;
        _start = 60; // Reset timer to 60 seconds
      });
      // Correctly call verifyPhoneNumber for resending OTP
      verificationController.verifyPhoneNumber(
        customPhoneNumber: verificationController.currentPhoneNumber.phoneNumber,
        gotoOTPPage: false,
      );
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_start > 0) {
            _start--;
          } else {
            _isResendAgain = false;
            timer.cancel();
          }
        });
      });
    }
  }

  verify() {
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 2000);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    _topBarComponent(),
                    SizedBox(
                      height: 23,
                    ),
                    _titleComponent(),
                    SizedBox(height: 37),
                    _otpBarComponent(authController),
                    _continueButtonComponent(authController),
                    _resendCodeComponent(authController),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _currentUserPhoneNumberComponent(AuthController authController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sent to ' + authController.currentPhoneNumber.phoneNumber!,
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              color: Color(0xFF5D6679),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: Color(0xFF3BC090),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Text(
            "Change number",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                color: Color(0xFF3BC090),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                height: 1.50,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _continueButtonComponent(AuthController authController) {
    return InkWell(
      onTap: authController.otpCode.length == 6
          ? () async {
              var isSuccessful = await authController.verifyOtp(otp: authController.otpCode);
              if (isSuccessful) Get.to(() => OnboardingAddressLocationPage());
            }
          : null,
      child: Container(
        height: 49,
        margin: EdgeInsets.symmetric(horizontal: 44),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: Color(0xFF3BC090),
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
        width: Get.width,
        child: _isLoading
            ? Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 3,
                  color: Colors.black,
                ),
              )
            : _isVerified
                ? Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 30,
                  )
                : Text(
                    "Continue",
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: Color(0xFFFDFBF9),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                        letterSpacing: 0.18,
                      ),
                    ),
                  ),
      ),
    );
  }

  Row _resendCodeComponent(AuthController authController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't get code?",
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              color: Color(0xFF1F382F),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(width: 5),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: _isResendAgain
              ? null
              : () {
                  authController.isFirstTimeTrying = false;
                  resend(authController);
                },
          child: Text(
            "Resend code",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                color: Color(0xFF1F986C),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Expanded _otpBarComponent(AuthController authController) {
    return Expanded(
      child: Container(
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VerificationCode(
                fullBorder: true,
                length: 6,
                itemSize: 50,
                textStyle: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                underlineColor: Color(0xFF3BC090),
                underlineWidth: 2,
                keyboardType: TextInputType.number,
                underlineUnfocusedColor: Color(0xFF989FAD),
                onCompleted: (value) {
                  setState(() {
                    authController.otpCode = value;
                  });
                },
                onEditing: (value) {},
              ),
              if (authController.isIncorrectCode)
                SizedBox(
                  height: 8,
                ),
              if (authController.isIncorrectCode)
                SizedBox(
                  width: Get.width,
                  child: Text(
                    "The code you entered is incorrect",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Color(0xFFF04437),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 16,
              ),
              if (authController.currentPhoneNumber.phoneNumber != null)
                _currentUserPhoneNumberComponent(authController),
            ],
          ),
        ),
      ),
    );
  }

  Column _titleComponent() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Enter your verification code",
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              color: Color(0xFF090F47),
              fontSize: 18.55,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.35,
            ),
          ),
        ),
        SizedBox(height: 15),
        Container(
          width: Get.width,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 0.50,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Color(0xFF7CBBA4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _topBarComponent() {
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
        ],
      ),
    );
  }
}
