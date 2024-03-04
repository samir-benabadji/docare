import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';

class OnboardingDoctorAccountDetailsPage extends StatefulWidget {
  const OnboardingDoctorAccountDetailsPage({Key? key}) : super(key: key);

  @override
  State<OnboardingDoctorAccountDetailsPage> createState() => _OnboardingDoctorAccountDetailsPageState();
}

class _OnboardingDoctorAccountDetailsPageState extends State<OnboardingDoctorAccountDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (onboardingController) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _topBarComponent(),
                  SizedBox(height: 32),
                  _titleComponent(),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Row(
                      children: [
                        _userImagePreviewComponent(onboardingController),
                        SizedBox(width: 32),
                        _userNameComponent(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 36,
                            width: 48,
                            color: Colors.transparent,
                            child: SvgPicture.asset(
                              Assets.icons.edit.path,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 115),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    child: _continueButtonComponent(onboardingController),
                  ),
                  SizedBox(height: 64)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _userNameComponent() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Hello, Dr. ',
            style: GoogleFonts.rubik(
              color: Color(0xFF090F47),
              fontSize: 14.33,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.27,
            ),
          ),
          TextSpan(
            text: 'Wissam',
            style: GoogleFonts.rubik(
              color: Color(0xFF090F47),
              fontSize: 14.33,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              letterSpacing: -0.27,
            ),
          ),
          TextSpan(
            text: '!',
            style: GoogleFonts.rubik(
              color: Color(0xFF090F47),
              fontSize: 14.33,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.27,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _userImagePreviewComponent(OnboardingController onboardingController) {
    return Container(
      width: 88,
      height: 88,
      child: ClipOval(
        child: Image.file(
          onboardingController.userImageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _titleComponent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "My Account Details",
          textAlign: TextAlign.center,
          style: GoogleFonts.rubik(
            color: Color(0xFF090F47),
            fontSize: 18.13,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.34,
          ),
        ),
        SizedBox(width: 32),
      ],
    );
  }

  Row _imageComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.images.creativePanelPlanner.path,
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
      ],
    );
  }

  Widget _continueButtonComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        width: Get.width,
        height: 49,
        margin: EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: _continueButtonColor(onboardingController),
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
          'Validate',
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

  Color _continueButtonColor(OnboardingController onboardingController) {
    return (onboardingController.nameController.text.isNotEmpty && onboardingController.nameController.text.length >= 2)
        ? Color(0xFF33CE95)
        : Color(0x6D53C298);
  }
}
