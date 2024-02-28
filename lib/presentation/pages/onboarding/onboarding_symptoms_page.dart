import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../business_logic/models/pain_model.dart';
import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_name_page.dart';

class OnboardingSymptomsPage extends StatefulWidget {
  const OnboardingSymptomsPage({Key? key}) : super(key: key);

  @override
  State<OnboardingSymptomsPage> createState() => _OnboardingSymptomsPageState();
}

class _OnboardingSymptomsPageState extends State<OnboardingSymptomsPage> {
  final List<PainType> painTypes = [
    PainType('Shoulder Pain', Assets.images.symptoms.shoulderPain.path),
    PainType('Knee Pain', Assets.images.symptoms.kneePain.path),
    PainType('Headache', Assets.images.symptoms.headache.path),
    PainType('Back Pain', Assets.images.symptoms.backPain.path),
    PainType('Finger Fracture', Assets.images.symptoms.fingerFracture.path),
    PainType('Hip Injury', Assets.images.symptoms.hipInjury.path),
    PainType('Foot Pain', Assets.images.symptoms.footPain.path),
    PainType('Elbow Pain', Assets.images.symptoms.elbowPain.path),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (onboardingController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _topBarComponent(),
                SizedBox(height: 32),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select your Symptoms',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xFF090F47),
                            fontSize: 16.68,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
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

  Widget _continueButtonComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () {
        if (onboardingController.selectedPainTypes.isNotEmpty) Get.to(() => OnboardingNamePage());
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

  Widget _mainContentComponent(OnboardingController onboardingController) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 18,
          mainAxisSpacing: 14,
          childAspectRatio: 0.725,
        ),
        itemCount: painTypes.length,
        itemBuilder: (context, index) {
          return GridTile(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildImageWithPlaceholder(painTypes[index], onboardingController: onboardingController),
                SizedBox(height: 6),
                Text(
                  painTypes[index].title,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageWithPlaceholder(PainType painType, {required OnboardingController onboardingController}) {
    return GestureDetector(
      onTap: () {
        onboardingController.toggleSelection(painType);
      },
      child: Stack(
        children: [
          Image.asset(
            painType.imagePath,
            fit: BoxFit.cover,
            width: 46.35,
            height: 46.35,
          ),
          if (onboardingController.isItemSelected(painType))
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                Assets.icons.checkGreen.path,
                height: 22,
                width: 22,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 46.35,
        height: 46.35,
        color: Colors.white,
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
          Spacer(),
          GestureDetector(
            child: Text(
              'Skip',
              style: GoogleFonts.montserrat(
                color: Color(0xFFFF0472),
                fontSize: 15.65,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _continueButtonColor(OnboardingController onboardingController) {
    return onboardingController.selectedPainTypes.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }
}
