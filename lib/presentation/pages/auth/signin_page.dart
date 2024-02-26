import 'package:docare/presentation/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/theme.dart';
import 'auth_controller.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GetBuilder<AuthController>(
            init: AuthController(), // Initialize AuthController
            builder: (authController) => Column(
              children: [
                _topBarComponent(),
                Spacer(),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff090F47),
                        ),
                      ),
                      SizedBox(height: 16),
                      _emailComponent(authController),
                      SizedBox(height: authController.invalidEmail ? 8 : 16),
                      _passwordComponent(authController),
                      /* if (controller.invalidEmail)
            _warningMessage(
              message: 'Please enter a valid email address.',
            ),
          if (controller.emailAlreadyInUse)
            _warningMessage(
              message:
                  'Oops! This email address is already linked to a Vegpal account. Please use a different email address to link it to your existing account.',
            ),*/
                      SizedBox(height: 16),
                      Text(
                        'I agree with the Terms of Service & Privacy Policy',
                        style: GoogleFonts.rubik(
                          color: Color(0xFF090F47),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.30,
                        ),
                      ),
                      SizedBox(height: 67),
                      _loginButtonComponent(authController),
                      SizedBox(height: 22),
                      Text(
                        'Forgot password',
                        style: GoogleFonts.rubik(
                          color: Color(0xFF090F47),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          letterSpacing: -0.30,
                        ),
                      ),
                      Obx(
                        () => Text(
                          authController.errorMessage.value,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
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

  Widget _loginButtonComponent(AuthController authController) {
    return GestureDetector(
      onTap: () => authController.signIn(authController.emailController.text, authController.passwordController.text),
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
          'Login ',
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
          hintText: 'Your email address',
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
        controller: authController.emailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an E-mail.';
          }

          if (!GetUtils.isEmail(value)) {
            authController.invalidEmail = true;
            authController.update();
            return 'Please enter a valid E-mail';
          }
          //TODO: Verifiy if email already exists
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
                    authController.obscureText ? "Show" : "Hide",
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
          hintText: 'Password',
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
        controller: authController.passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an E-mail.';
          }

          if (!GetUtils.isEmail(value)) {
            return 'Enter a valid E-mail';
          }
          //TODO: Verifiy if email already exists
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
