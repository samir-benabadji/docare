import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';

class OnboardingSessionOptionAssociationPage extends StatefulWidget {
  const OnboardingSessionOptionAssociationPage({Key? key}) : super(key: key);

  @override
  State<OnboardingSessionOptionAssociationPage> createState() => _OnboardingSessionOptionAssociationPageState();
}

class _OnboardingSessionOptionAssociationPageState extends State<OnboardingSessionOptionAssociationPage> {
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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Session's duration",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Color(0xFF090F47),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.26,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _mainContentComponent(onboardingController),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
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
        ],
      ),
    );
  }

  Widget _mainContentComponent(OnboardingController onboardingController) {
    return Expanded(
      child: ListView.builder(
        itemCount: onboardingController.selectedOptions.length,
        itemBuilder: (context, index) {
          final SelectedOption selectedOption = onboardingController.selectedOptions[index];
          return GestureDetector(
            onTap: () {
              Get.back(result: selectedOption.name);
            },
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 8,
                top: 8,
                bottom: 8,
              ),
              margin: EdgeInsets.only(bottom: 15),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                shadows: [
                  BoxShadow(
                    color: Color(0x333BC090),
                    blurRadius: 4,
                    offset: Offset(3, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      selectedOption.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 14.96,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
}
