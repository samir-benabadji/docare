import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../business_logic/models/doctor_options.dart';
import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_rates_page.dart';
import 'onboarding_specific_option_page.dart';

class OnboardingOptionsPage extends StatefulWidget {
  const OnboardingOptionsPage({Key? key}) : super(key: key);

  @override
  State<OnboardingOptionsPage> createState() => _OnboardingOptionsPageState();
}

class _OnboardingOptionsPageState extends State<OnboardingOptionsPage> {
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
                _titleComponent(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 36),
                        _mainContentComponent(onboardingController),
                        _otherOptionButton(context, onboardingController),
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

  Widget _titleComponent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.configureOtherEquipmentAndSpecialtiesText,
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
          SizedBox(height: 24),
          Container(
            width: Get.width,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFDEDEDE),
                ),
              ),
            ),
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
      child: ListView.builder(
        itemCount: onboardingController.options.length,
        itemBuilder: (context, index) {
          final DoctorOption option = onboardingController.options[index];
          final bool isSelected =
              onboardingController.selectedOptions.any((selectedOption) => selectedOption.id == option.id);
          return Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  if (value != null) {
                    onboardingController.toggleOptionSelection(option);
                  }
                },
              ),
              Expanded(
                child: Text(
                  option.title,
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 14.96,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
            ],
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

  Widget _otherOptionButton(BuildContext context, OnboardingController onboardingController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: TextButton(
            onPressed: () async {
              SelectedOption? newOption = await Get.to(() => OnboardingSpecificOptionsPage());
              if (newOption != null && newOption.name.isNotEmpty) {
                onboardingController.options.add(DoctorOption(newOption.id, newOption.name));
                onboardingController.selectedOptions.add(newOption);
                onboardingController.sortOptions();
              }
            },
            child: Text(
              AppLocalizations.of(context)!.otherText,
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                color: Color(0xFF090F47),
                fontSize: 15.78,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                letterSpacing: -0.30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _continueButtonColor(OnboardingController onboardingController) {
    return onboardingController.selectedOptions.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }
}
