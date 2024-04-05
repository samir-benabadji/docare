import 'package:docare/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_doctor_account_details_page.dart';

class OnboardingNamePage extends StatefulWidget {
  const OnboardingNamePage({Key? key}) : super(key: key);

  @override
  State<OnboardingNamePage> createState() => _OnboardingNamePageState();
}

class _OnboardingNamePageState extends State<OnboardingNamePage> {
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
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    child: Form(
                      key: onboardingController.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleComponent(),
                          TextFormField(
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Color(0xFF100C08),
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.30,
                              ),
                            ),
                            onChanged: (value) {
                              onboardingController.update();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.pleaseEnterEmailErrorMessage;
                              }
                              if (value.length < 2) {
                                return AppLocalizations.of(context)!.nameLengthValidatorErrorMessage;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 8),
                              hintText: AppLocalizations.of(context)!.nameHintText,
                              hintStyle: GoogleFonts.openSans(
                                textStyle: GoogleFonts.openSans(
                                  color: Color(0xFF858D9D),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: onboardingController.nameController,
                          ),
                          SizedBox(height: 52),
                          _imageComponent(),
                        ],
                      ),
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
                AppLocalizations.of(context)!.helpText,
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
      onTap: () async {
        if (onboardingController.userModel != null && onboardingController.userModel!.userType == 1) {
          if (onboardingController.validateForm()) Get.offAll(() => OnboardingDoctorAccountDetailsPage());
        } else {
          if (onboardingController.validateForm()) {
            bool success = await onboardingController.updateUserInfo();
            if (success) {
              if (onboardingController.userModel != null)
                Get.offAll(
                  () => HomePage(
                    userModel: onboardingController.userModel!,
                  ),
                );
            } else {}
          }
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
