import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets.gen.dart';
import '../auth/signin_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.dOCARELogoText.path,
            ),
            SizedBox(height: 48),
            Text(
              'Your Health, Our Priority Connect with top doctors for personalized consultations anytime, anywhere with Your Virtual Clinic.',
              textAlign: TextAlign.center,
              style: GoogleFonts.itim(
                color: Color(0xFF090F47),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 120),
            GestureDetector(
              onTap: () {
                Get.off(() => SignInPage());
              },
              child: Stack(
                children: [
                  SvgPicture.asset(
                    Assets.images.docareButtonLayout.path,
                  ),
                  Container(
                    width: 166,
                    height: 49,
                    alignment: Alignment.center,
                    child: Text(
                      'Continue',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFF090F47),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
