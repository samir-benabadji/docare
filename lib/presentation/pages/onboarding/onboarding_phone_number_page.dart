import 'package:docare/presentation/pages/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_address_location_page.dart';
import 'onboarding_controller.dart';

class OnboardingPhoneNumberPage extends StatefulWidget {
  const OnboardingPhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPhoneNumberPage> createState() => _OnboardingPhoneNumberPageState();
}

class _OnboardingPhoneNumberPageState extends State<OnboardingPhoneNumberPage> {
  final authController = Get.find<AuthController>();
  final FocusNode phoneNumberFocusNode = FocusNode();

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
                        Spacer(),
                        _sendCodeComponent(onboardingController),
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
        AppLocalizations.of(context)!.verificationText,
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
                  AppLocalizations.of(context)!.enterPhoneNumber,
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

  Widget _sendCodeComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () {
        if (authController.isValidNumber) {
          // Passing the current phone number to the verifyPhoneNumber method
          authController.verifyPhoneNumber(customPhoneNumber: authController.currentPhoneNumber.phoneNumber);
        } else {
          if (authController.textEditingPhoneController.text.isEmpty) {
            phoneNumberFocusNode.requestFocus();
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
          AppLocalizations.of(context)!.sendCode,
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

  Widget _loginWithPhoneNumber() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color(0xFF5D6679),
                ),
              ),
            ),
            child: InternationalPhoneNumberInput(
              initialValue: authController.defaultCountryPhone,
              onInputChanged: (PhoneNumber number) {
                authController.currentPhoneNumber = number;
                authController.isValidNumber = number.dialCode != number.phoneNumber;
                authController.update();
              },
              onSaved: (PhoneNumber number) {
                authController.currentPhoneNumber = number;
                authController.update();
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              spaceBetweenSelectorAndTextField: 0,
              ignoreBlank: false,
              focusNode: phoneNumberFocusNode,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.grey),
              textFieldController: authController.textEditingPhoneController,
              formatInput: false,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              cursorColor: Colors.black,
              textStyle: GoogleFonts.openSans(
                color: Color(0xFF100C08),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.30,
              ),
              inputDecoration: InputDecoration(
                errorStyle: GoogleFonts.openSans(
                  color: Color(0xFFF04437),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 10, left: 0),
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.phoneNumber,
                hintStyle: GoogleFonts.openSans(
                  color: Color(0xFF858D9D),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        if (authController.verificationFailedWithPhone != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              width: double.infinity,
              child: Text(
                authController.verificationFailedWithPhone!,
                style: GoogleFonts.openSans(
                  textStyle: GoogleFonts.openSans(
                    color: Color(0xFFF04437),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _mainContentComponent(OnboardingController onboardingController) {
    return _loginWithPhoneNumber();
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
            onTap: () {
              Get.to(() => OnboardingAddressLocationPage());
            },
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
    return onboardingController.selectedOptions.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }
}
