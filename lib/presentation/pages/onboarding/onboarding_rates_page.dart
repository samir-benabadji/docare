import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_name_page.dart';

class OnboardingRatesPage extends StatefulWidget {
  const OnboardingRatesPage({Key? key}) : super(key: key);

  @override
  State<OnboardingRatesPage> createState() => _OnboardingRatesPageState();
}

class _OnboardingRatesPageState extends State<OnboardingRatesPage> {
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
                        SizedBox(height: 36),
                        _mainContentComponent(onboardingController),
                        _addEquipmentButton(context, onboardingController),
                      ],
                    ),
                  ),
                ),
                _continueButtonComponent(onboardingController),
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
                  "Enter the rates",
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
        bool hasZeroPrice = onboardingController.selectedOptions.any((option) => option.price == 0.0);
        if (onboardingController.selectedOptions.isNotEmpty && !hasZeroPrice) {
          // TODO: take him to the work schedule page
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

  Widget _mainContentComponent(OnboardingController onboardingController) {
    return Expanded(
      child: ListView.builder(
        itemCount: onboardingController.selectedOptions.length,
        itemBuilder: (context, index) {
          final SelectedOption selectedOption = onboardingController.selectedOptions[index];
          return Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    selectedOption.name,
                    style: GoogleFonts.rubik(
                      color: Colors.black,
                      fontSize: 14.96,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.28,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '\$ ',
                  style: GoogleFonts.rubik(
                    color: Color(0xFF090F47),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 0.87,
                    letterSpacing: -0.46,
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: TextEditingController(
                      text: selectedOption.price.toString(),
                    ),
                    onChanged: (value) {
                      selectedOption.price = double.parse(value);
                    },
                    style: GoogleFonts.rubik(
                      color: Color(0xFF090F47),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 0.87,
                      letterSpacing: -0.46,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
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

  Widget _addEquipmentButton(BuildContext context, OnboardingController onboardingController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: TextButton(
            onPressed: () async {
              Get.back();
            },
            child: Text(
              'Add Equipments',
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
    bool hasZeroPrice = onboardingController.selectedOptions.any((option) => option.price == 0.0);
    return onboardingController.selectedOptions.isNotEmpty && !hasZeroPrice ? Color(0xFF33CE95) : Color(0x6D53C298);
  }
}
