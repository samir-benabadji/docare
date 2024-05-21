import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/assets.gen.dart';
import '../../../l10n/l10n.dart';
import '../auth/signin_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            icon: Icon(Icons.language, color: Colors.black),
            elevation: 0,
            onChanged: (Locale? locale) {
              if (locale != null) {
                Get.updateLocale(locale);
              }
            },
            items: L10n.all.map<DropdownMenuItem<Locale>>((Locale locale) {
              final String languageCode = locale.languageCode;
              return DropdownMenuItem<Locale>(
                value: locale,
                child: Text(languageCode.toUpperCase()),
              );
            }).toList(),
          ),
        ),
      ),
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
              AppLocalizations.of(context)!.welcomePageIntroductionMessage,
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
                      AppLocalizations.of(context)!.continueButtonText,
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
