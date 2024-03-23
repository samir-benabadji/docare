import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/assets.gen.dart';

class AppointmentCreatedSuccessfullyComponent extends StatefulWidget {
  @override
  State<AppointmentCreatedSuccessfullyComponent> createState() => _AppointmentCreatedSuccessfullyComponentState();
}

class _AppointmentCreatedSuccessfullyComponentState extends State<AppointmentCreatedSuccessfullyComponent> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: _titleView(),
      content: _contentView(),
    );
  }

  Widget _titleView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Appointement made succesfully',
          style: GoogleFonts.rubik(
            color: Color(0xFF3BC090),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.35,
          ),
        ),
      ],
    );
  }

  Widget _contentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 180,
          width: 180,
          child: Image.asset(
            Assets.images.doctorProfile.appointmentCreated.path,
            fit: BoxFit.cover,
            cacheHeight: 180,
            cacheWidth: 180,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'You will receive confirmation ',
                style: GoogleFonts.openSans(
                  color: Color(0xFF090F47),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'soon',
                style: GoogleFonts.openSans(
                  color: Color(0xFF090F47),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
