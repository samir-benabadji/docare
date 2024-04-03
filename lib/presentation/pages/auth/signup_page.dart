import 'package:docare/presentation/pages/auth/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets.gen.dart';
import '../../../core/constants/theme.dart';
import 'auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GetBuilder<AuthController>(
            builder: (authController) => SingleChildScrollView(
              child: Column(
                children: [
                  _topBarComponent(),
                  SizedBox(height: 55),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.signUpPageTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff090F47),
                          ),
                        ),
                        SizedBox(height: 16),
                        _toggleButtonComponent(authController),
                        SizedBox(height: 12),
                        Form(
                          key: authController.signUpFormKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                _emailComponent(authController),
                                SizedBox(height: authController.invalidEmail ? 8 : 16),
                                _passwordComponent(authController),
                                SizedBox(height: authController.invalidEmail ? 8 : 16),
                                _confirmPasswordComponent(authController),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.agreeTermsMessage,
                          style: GoogleFonts.rubik(
                            color: Color(0xFF090F47),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 34),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _signUpButtonComponent(authController),
                            SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.alreadyHaveAccountText,
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFFA5A5A5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.22,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.off(() => SignInPage()),
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.only(bottom: 8, right: 16),
                                    child: Text(
                                      AppLocalizations.of(context)!.loginText,
                                      style: GoogleFonts.poppins(
                                        color: Color(0xFF090F47),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        letterSpacing: -0.22,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 22),
                        Obx(
                          () => Text(
                            authController.errorMessage.value,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _toggleButtonComponent(AuthController authController) {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0x77F2F2F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19.39),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              authController.selectedUserType = 2;
              authController.update();
            },
            child: Container(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                width: 136.17,
                decoration: authController.selectedUserType == 2
                    ? ShapeDecoration(
                        color: Color(0xFF3BC090),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38.78),
                        ),
                      )
                    : null,
                child: Text(
                  AppLocalizations.of(context)!.patientOptionText,
                  style: GoogleFonts.poppins(
                    color: authController.selectedUserType == 2 ? Colors.white : Color(0xFF3BC090),
                    fontSize: 17.32,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              authController.selectedUserType = 1;
              authController.update();
            },
            child: Container(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                width: 136.17,
                decoration: authController.selectedUserType == 1
                    ? ShapeDecoration(
                        color: Color(0xFF3BC090),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38.78),
                        ),
                      )
                    : null,
                child: Text(
                  AppLocalizations.of(context)!.doctorOptionText,
                  style: GoogleFonts.poppins(
                    color: authController.selectedUserType == 1 ? Colors.white : Color(0xFF3BC090),
                    fontSize: 17.32,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailComponent(AuthController authController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
              SvgPicture.asset(
                Assets.icons.auth.address.path,
                fit: BoxFit.scaleDown,
              ),
            ],
          ),
          hintText: AppLocalizations.of(context)!.emailHintText,
          hintStyle: GoogleFonts.openSans(
            textStyle: GoogleFonts.openSans(
              color: Color(0xFF858D9D),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        controller: authController.signUpEmailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an E-mail.';
          }

          if (!GetUtils.isEmail(value)) {
            authController.invalidEmail = true;
            authController.update();
            return 'Please enter a valid E-mail';
          }
          //TODO: Verify if email already exists
          return null;
        },
        onSaved: (value) {
          // controller.emailController.text = value!;
        },
        onFieldSubmitted: (value) {
          // controller.emailController.text = value;
        },
        onChanged: (value) {
          // controller.saveForm(form);
          authController.update();
        },
      ),
    );
  }

  Widget _signUpButtonComponent(AuthController authController) {
    return GestureDetector(
      onTap: () {
        if (authController.validateSignUpForm()) {
          authController.signUp(
            authController.signUpEmailController.text,
            authController.signUpPasswordController.text,
            authController.selectedUserType,
          );
        }
      },
      child: Container(
        width: 185,
        height: 46,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: DocareTheme.apple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.36),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.signUpButtonText,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17.51,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.33,
          ),
        ),
      ),
    );
  }

  Widget _passwordComponent(AuthController authController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: Color(0xFF100C08),
            fontSize: 20,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.30,
          ),
        ),
        obscureText: authController.obscureText,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24, maxHeight: 24, maxWidth: 40),
          prefixIcon: Row(
            children: [
              SvgPicture.asset(
                Assets.icons.auth.lock.path,
                fit: BoxFit.scaleDown,
              ),
            ],
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              authController.obscureText = !authController.obscureText;
              authController.update();
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    authController.obscureText
                        ? AppLocalizations.of(context)!.showPasswordText
                        : AppLocalizations.of(context)!.hidePasswordText,
                    style: GoogleFonts.openSans(
                      color: Color(0xFF5D6679),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          hintText: AppLocalizations.of(context)!.passwordHintText,
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
        controller: authController.signUpPasswordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a password.';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters long.';
          }
          if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{6,}$').hasMatch(value)) {
            return 'Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.';
          }
          return null;
        },
        onSaved: (value) {
          // controller.emailController.text = value!;
        },
        onFieldSubmitted: (value) {
          // controller.emailController.text = value;
        },
        onChanged: (value) {
          // controller.saveForm(form);
          // controller.update();
        },
      ),
    );
  }

  Widget _confirmPasswordComponent(AuthController authController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: Color(0xFF100C08),
            fontSize: 20,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.30,
          ),
        ),
        obscureText: authController.obscureText,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24, maxHeight: 24, maxWidth: 40),
          prefixIcon: Row(
            children: [
              SvgPicture.asset(
                Assets.icons.auth.lockCheck.path,
                fit: BoxFit.scaleDown,
              ),
            ],
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              authController.obscureText = !authController.obscureText;
              authController.update();
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    authController.obscureText
                        ? AppLocalizations.of(context)!.showPasswordText
                        : AppLocalizations.of(context)!.hidePasswordText,
                    style: GoogleFonts.openSans(
                      color: Color(0xFF5D6679),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          hintText: AppLocalizations.of(context)!.confirmPasswordHintText,
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
        controller: authController.signUpConfirmPasswordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a confirmation password.';
          }
          if (value != authController.signUpPasswordController.text) {
            return 'Passwords do not match.';
          }
          return null;
        },
        onSaved: (value) {
          // controller.emailController.text = value!;
        },
        onFieldSubmitted: (value) {
          // controller.emailController.text = value;
        },
        onChanged: (value) {
          // controller.saveForm(form);
          // controller.update();
        },
      ),
    );
  }

  Widget _topBarComponent() {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.icons.dOCARELogo.path,
        ),
        SizedBox(width: 2),
        SvgPicture.asset(
          Assets.icons.dOCAREText.path,
        ),
      ],
    );
  }
}
