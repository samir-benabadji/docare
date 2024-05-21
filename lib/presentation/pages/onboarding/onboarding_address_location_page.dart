import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_manual_location_page.dart';

class OnboardingAddressLocationPage extends StatefulWidget {
  const OnboardingAddressLocationPage({Key? key}) : super(key: key);

  @override
  State<OnboardingAddressLocationPage> createState() => _OnboardingAddressLocationPageState();
}

class _OnboardingAddressLocationPageState extends State<OnboardingAddressLocationPage> {
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
                SizedBox(height: 23),
                _locationTrackingImageComponent(),
                SizedBox(height: 25),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleComponent(),
                        SizedBox(height: 25),
                        _descriptionComponent(),
                        SizedBox(height: 55),
                        // allowLocationAccessButtonComponent(onboardingController),
                        //  SizedBox(height: 18),
                        _manualLocationButtonComponent(onboardingController),
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

  Widget _titleComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.locationQuestion,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            color: Color(0xFF090F47),
            fontSize: 16.68,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _descriptionComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.locationRecommendation,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              color: Color(0xFF878787),
              fontSize: 15.83,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.30,
            ),
          ),
        ),
      ],
    );
  }

  Image _locationTrackingImageComponent() {
    return Image.asset(
      Assets.images.locationTracking.path,
      width: 250,
      height: 250,
    );
  }

  Widget _manualLocationButtonComponent(OnboardingController onboardingController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => OnboardingManualLocationPage());
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            color: Colors.transparent,
            child: Text(
              AppLocalizations.of(context)!.enterLocationManually,
              style: GoogleFonts.rubik(
                color: Color(0xFF7ACDAF),
                fontSize: 18.55,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.35,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget allowLocationAccessButtonComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () {
        onboardingController.requestLocationAccess();
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
          AppLocalizations.of(context)!.allowLocationAccess,
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
    return onboardingController.selectedPainTypes.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }
}
