import 'package:docare/presentation/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/theme.dart';
import 'auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPage extends StatelessWidget {
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
                  SizedBox(height: Get.height * 0.1),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.loginPageTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff090F47),
                          ),
                        ),
                        SizedBox(height: 16),
                        Form(
                          key: authController.loginFormKey,
                          child: Column(
                            children: [
                              _emailComponent(context, authController),
                              SizedBox(height: authController.invalidEmail ? 8 : 16),
                              _passwordComponent(context, authController),
                              SizedBox(height: 16),
                            ],
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
                        SizedBox(height: 67),
                        _loginButtonComponent(context, authController),
                        SizedBox(height: 22),
                        Text(
                          AppLocalizations.of(context)!.forgotPasswordText,
                          style: GoogleFonts.rubik(
                            color: Color(0xFF090F47),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            letterSpacing: -0.30,
                          ),
                        ),
                        SizedBox(height: 8),
                        Obx(
                          () => Text(
                            authController.errorMessage.value,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
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
        Spacer(),
        GestureDetector(
          onTap: () => Get.to(() => SignUpPage()),
          child: SvgPicture.asset(
            Assets.icons.newUser.path,
          ),
        ),
      ],
    );
  }

  Widget _loginButtonComponent(BuildContext context, AuthController authController) {
    return GestureDetector(
      onTap: () {
        if (authController.validateLoginForm()) {
          authController.signIn(
            authController.loginEmailController.text,
            authController.loginPasswordController.text,
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
          AppLocalizations.of(context)!.loginButtonLabel,
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

  Widget _emailComponent(BuildContext context, AuthController authController) {
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
        controller: authController.loginEmailController,
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.pleaseEnterEmailErrorMessage;
          }

          if (!GetUtils.isEmail(value)) {
            authController.invalidEmail = true;
            authController.update();
            return AppLocalizations.of(context)!.pleaseEnterValidEmailErrorMessage;
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

  Widget _passwordComponent(BuildContext context, AuthController authController) {
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
        controller: authController.loginPasswordController,
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.pleaseEnterPasswordErrorMessage;
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
}
