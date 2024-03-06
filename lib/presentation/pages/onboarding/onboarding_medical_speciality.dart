import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../business_logic/models/speciality_model.dart';
import '../../../business_logic/models/user_model.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/constants.dart';
import 'onboarding_controller.dart';
import 'onboarding_symptoms_page.dart';

class OnboardingMedicalSpecialityPage extends StatefulWidget {
  UserModel userModel;
  OnboardingMedicalSpecialityPage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<OnboardingMedicalSpecialityPage> createState() => _OnboardingMedicalSpecialityPageState();
}

class _OnboardingMedicalSpecialityPageState extends State<OnboardingMedicalSpecialityPage> {
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Select Your Medical Specialty',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(
                            color: Color(0xFF090F47),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.50,
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
        if (onboardingController.selectedSpecialityType.value.title.isNotEmpty) {
          if (onboardingController.userModel != null)
            Get.to(
              () => OnboardingSymptomsPage(userModel: onboardingController.userModel!),
            );
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
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 14,
          childAspectRatio: 1.5,
        ),
        itemCount: Constants.specialityTypes.length,
        itemBuilder: (context, index) {
          return GridTile(
            child: GestureDetector(
              onTap: () {
                onboardingController.setMedicalSpeciality(Constants.specialityTypes[index]);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Color(0xFFFAFFFD),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.50,
                      color: onboardingController.selectedSpecialityType.value == Constants.specialityTypes[index]
                          ? Color(0xFF3BC090)
                          : Color(0xFF090F47),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildImageWithPlaceholder(
                      Constants.specialityTypes[index],
                      onboardingController: onboardingController,
                    ),
                    SizedBox(height: 6),
                    Text(
                      Constants.specialityTypes[index].title,
                      style: GoogleFonts.rubik(
                        color: Color(0xFF090F47),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageWithPlaceholder(
    SpecialityType specialityType, {
    required OnboardingController onboardingController,
  }) {
    return Image.asset(
      specialityType.imagePath,
      fit: BoxFit.cover,
      width: 46.35,
      height: 46.35,
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
        ],
      ),
    );
  }

  Color _continueButtonColor(OnboardingController onboardingController) {
    return onboardingController.selectedSpecialityType.value.title.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }
}
