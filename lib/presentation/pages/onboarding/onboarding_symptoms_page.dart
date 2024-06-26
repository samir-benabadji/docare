import 'package:docare/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../business_logic/models/pain_model.dart';
import '../../../business_logic/models/user_model.dart';
import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_name_page.dart';
import 'onboarding_options_page.dart';

class OnboardingSymptomsPage extends StatefulWidget {
  final UserModel userModel;
  const OnboardingSymptomsPage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<OnboardingSymptomsPage> createState() => _OnboardingSymptomsPageState();
}

class _OnboardingSymptomsPageState extends State<OnboardingSymptomsPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      initState: (state) {
        Get.find<OnboardingController>().getUserDataModel();
      },
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
                          onboardingController.userModel?.userType == 1
                              ? AppLocalizations.of(context)!.helpText
                              : AppLocalizations.of(context)!.selectSymptomsText,
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
        if (onboardingController.selectedPainTypes.isNotEmpty) {
          onboardingController.userModel?.userType == 1
              ? Get.to(() => OnboardingOptionsPage())
              : Get.to(() => OnboardingNamePage());
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
        itemCount: Constants.painTypes.length,
        itemBuilder: (context, index) {
          return GridTile(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildImageWithPlaceholder(Constants.painTypes[index], onboardingController: onboardingController),
                SizedBox(height: 6),
                Text(
                  Constants.painTypes[index].title,
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
        onboardingController.togglePainTypeSelection(painType);
      },
      child: Stack(
        children: [
          Image.asset(
            painType.imagePath,
            fit: BoxFit.cover,
            width: 46.35,
            height: 46.35,
          ),
          if (onboardingController.selectedPainTypes.contains(painType))
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
              AppLocalizations.of(context)!.skipButtonText,
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
