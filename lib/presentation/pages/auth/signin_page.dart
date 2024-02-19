import 'package:docare/presentation/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_controller.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GetBuilder<AuthController>(
            init: AuthController(), // Initialize AuthController
            builder: (authController) => Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/DOCARE_logo.svg",
                    ),
                    SizedBox(width: 2),
                    SvgPicture.asset(
                      "assets/icons/DOCARE_text.svg",
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Get.to(() => SignUpPage()),
                      child: SvgPicture.asset(
                        "assets/icons/new_user.svg",
                      ),
                    ),
                  ],
                ),
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
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password"),
                      ),
                      ElevatedButton(
                        onPressed: () => authController.signIn(emailController.text, passwordController.text),
                        child: Text("Sign In"),
                      ),
                      Obx(() => Text(
                            authController.errorMessage.value,
                            style: TextStyle(color: Colors.red),
                          )),
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
}
