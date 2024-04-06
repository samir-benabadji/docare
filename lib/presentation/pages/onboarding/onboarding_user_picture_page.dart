import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_user_preview_image_page.dart';

class OnboardingUserPicturePage extends StatefulWidget {
  const OnboardingUserPicturePage({Key? key}) : super(key: key);

  @override
  State<OnboardingUserPicturePage> createState() => _OnboardingUserPicturePageState();
}

class _OnboardingUserPicturePageState extends State<OnboardingUserPicturePage> {
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
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _titleComponent(),
                        SizedBox(height: 16),
                        _descriptionComponent(),
                        SizedBox(height: 13),
                        _imageUploadComponent(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                _uploadProfilePicutreButtonComponent(onboardingController),
                SizedBox(height: 32)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _descriptionComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!.boostVisibilityMessage,
              style: GoogleFonts.rubik(
                color: Color(0xFF090F47),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.22,
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context)!.attract,
              style: GoogleFonts.rubik(
                color: Color(0xFF090F47),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                letterSpacing: -0.22,
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context)!.clientsUploadYourImageNowTo,
              style: GoogleFonts.rubik(
                color: Color(0xFF090F47),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.22,
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context)!.increaseYourChances,
              style: GoogleFonts.rubik(
                color: Color(0xFF090F47),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                letterSpacing: -0.22,
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context)!.ofConnectingWithMorePatients,
              style: GoogleFonts.rubik(
                color: Color(0xFF090F47),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.22,
              ),
            ),
            TextSpan(
              text: '!',
              style: GoogleFonts.rubik(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.22,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Image _imageUploadComponent() {
    return Image.asset(
      Assets.images.imageUpload.path,
      width: 306,
      height: 306,
    );
  }

  Widget _uploadProfilePicutreButtonComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () {
        Get.to(() => OnboardingUserPreviewImagePage());
      },
      child: Container(
        width: Get.width,
        height: 49,
        margin: EdgeInsets.symmetric(horizontal: 56),
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
          AppLocalizations.of(context)!.uploadProfilePicture,
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

  Widget _titleComponent() {
    return Column(
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
                AppLocalizations.of(context)!.timeForAPicture,
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
