import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';

class OnboardingSpecificOptionsPage extends StatefulWidget {
  @override
  State<OnboardingSpecificOptionsPage> createState() => _OnboardingSpecificOptionsPageState();
}

class _OnboardingSpecificOptionsPageState extends State<OnboardingSpecificOptionsPage> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topBarComponent(),
            SizedBox(height: 32),
            _titleComponent(),
            SizedBox(height: 64),
            _specificOptionComponent(),
            Spacer(),
            _continueButtonComponent(),
            SizedBox(height: 32)
          ],
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

  Widget _specificOptionComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        style: GoogleFonts.openSans(
          textStyle: GoogleFonts.openSans(
            color: Color(0xFF100C08),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.30,
          ),
        ),
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24, maxHeight: 24, maxWidth: 40),
          prefixIcon: Row(
            children: [
              Image.asset(
                Assets.icons.syringe.path,
              ),
            ],
          ),
          hintText: AppLocalizations.of(context)!.optimizeEquipmentAndSpecialtiesText,
          hintStyle: GoogleFonts.rubik(
            color: Color(0xFFB3B3B3),
            fontSize: 15,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.23,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        controller: _textFieldController,
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.pleaseEnterSpecificOptionErrorMessage;
          }

          return null;
        },
        onChanged: (value) {
          setState(() {});
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

  Widget _continueButtonComponent() {
    return GestureDetector(
      onTap: () {
        if (_textFieldController.text.isNotEmpty) {
          Get.back(
            result: SelectedOption(
              _textFieldController.text,
              id: Uuid().v4(),
            ),
          );
        } else {}
      },
      child: Container(
        width: Get.width,
        height: 49,
        margin: EdgeInsets.symmetric(horizontal: 44),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: _continueButtonColor(),
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

  Color _continueButtonColor() {
    return _textFieldController.text.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }
}
