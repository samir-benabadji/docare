import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_rates_page.dart';

class OnboardingPhoneNumberPage extends StatefulWidget {
  const OnboardingPhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPhoneNumberPage> createState() => _OnboardingPhoneNumberPageState();
}

class _OnboardingPhoneNumberPageState extends State<OnboardingPhoneNumberPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      initState: (state) {},
      builder: (onboardingController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _topBarComponent(),
                SizedBox(height: 32),
                _titleComponent(),
                SizedBox(height: 8),
                _descriptionComponent(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 36),
                        _mainContentComponent(onboardingController),
                        _continueButtonComponent(onboardingController),
                        SizedBox(height: 32)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _descriptionComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Text(
        'We’ll send a text with a verification code. Message and data rates may apply.',
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
          color: Color(0xFF5D6679),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _titleComponent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
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
                  "Enter your phone number",
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
        ],
      ),
    );
  }

  Widget _continueButtonComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () {
        if (onboardingController.selectedOptions.isNotEmpty) {
          Get.to(() => OnboardingRatesPage());
        }
      },
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
          'Send code',
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

  Widget _mainContentComponent(OnboardingController onboardingController) {
    return Container();
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
    return onboardingController.selectedOptions.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }
}
