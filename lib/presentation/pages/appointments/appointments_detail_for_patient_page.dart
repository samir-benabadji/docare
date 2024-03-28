import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docare/business_logic/models/pain_model.dart';
import 'package:docare/business_logic/models/user_model.dart';
import 'package:docare/business_logic/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../business_logic/models/appointment_model.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/constants.dart';
import '../../../core/constants/theme.dart';
import '../../widgets/utils.dart';
import 'appointments_controller.dart';

class AppointmentsDetailForPatientPage extends StatelessWidget {
  final AppointmentModel appointment;
  AppointmentsDetailForPatientPage({required this.appointment});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentsController>(
      init: AppointmentsController(),
      builder: (appointmentsController) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _topBarComponent(),
                  SizedBox(height: 6),
                  _appointmentDetailsTitleComponent(),
                  SizedBox(height: 22),
                  _appointmentDetailsMainContent(appointmentsController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dividerComponent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      height: 1,
      width: Get.width,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x26090F47),
          ),
        ),
      ),
    );
  }

  Widget _appointmentDetailsTitleComponent() {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset(
              Assets.icons.leftArrow.path,
            ),
          ),
          Text(
            "Appointment Details",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _appointmentDetailsMainContent(AppointmentsController appointmentsController) {
    return StreamBuilder<UserModel?>(
      stream: appointmentsController.doctorUserModelStream.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // TODO: Show a proper message to the user
        } else if (snapshot.data == null) {
          return Expanded(
            child: Center(
              child: Text('Sorry, we couldn\'t load the doctor\'s information.'),
            ),
          );
        } else {
          final doctorUserModel = snapshot.data!;
          return _appointmentDetailsComponent(doctorUserModel, appointmentsController);
        }
      },
    );
  }

  Widget _appointmentDetailsComponent(UserModel doctorUserModel, AppointmentsController appointmentsController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _doctorImageWithNameAndSpecialityComponent(doctorUserModel),
        SizedBox(height: 21),
        _patientSymptomsComponent(),
        SizedBox(height: 18),
        _dividerComponent(),
        SizedBox(height: 11),
        _optionContentComponent(),
        SizedBox(height: 18),
        _rateContentComponent(),
        SizedBox(height: 18),
        _sessionTimeContentComponent(),
        SizedBox(height: 15),
        _dividerComponent(),
        SizedBox(height: 15),
        _visitTimeContentComponent(),
        SizedBox(height: 28),
        _dividerComponent(),
        SizedBox(height: 15),
        _patientInformationsContentComponent(),
        SizedBox(height: 32),
        _cancelAppointmentButtonComponent(appointmentsController),
        SizedBox(height: 24)
      ],
    );
  }

  Widget _cancelAppointmentButtonComponent(AppointmentsController appointmentsController) {
    DateTime appointmentDateTime = DateTime.fromMillisecondsSinceEpoch(appointment.appointmentTimeStamp);
    DateTime currentDateTime = DateTime.now();
    bool is24HoursAhead = appointmentDateTime.isAfter(currentDateTime.add(Duration(hours: 24)));

    return GestureDetector(
      onTap: () {
        if (is24HoursAhead) {
          appointmentsController.cancelAppointment(appointment.id);
        } else {
          showToast('You cannot cancel appointments within 24 hours of the scheduled time.');
        }
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 40),
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: ShapeDecoration(
          color: is24HoursAhead ? DocareTheme.apple : DocareTheme.babyApple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          shadows: [
            BoxShadow(
              color: Color(0xff494949).withOpacity(0.25),
              blurRadius: 4.60,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
        ),
        child: Text(
          'Cancel the appointment',
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

  Widget _visitTimeContentComponent() {
    DateTime appointmentDate = DateTime.fromMillisecondsSinceEpoch(appointment.appointmentTimeStamp);
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(appointmentDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visit Time',
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 15.57,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text(
            formattedDate,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "${appointment.startAt.split(' ')[0]} - ${appointment.endAt.split(' ')[0]}",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _patientInformationsContentComponent() {
    UserModel? patientUserModel = Get.find<FirebaseFirestoreService>().getUserModel;
    DateTime? birthDateTime;
    if (patientUserModel != null && patientUserModel.birthDate != null) {
      Timestamp? birthTimestamp = patientUserModel.birthDate;
      if (birthTimestamp != null) birthDateTime = birthTimestamp.toDate();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Information',
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 15.57,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Full Name: ${patientUserModel?.name ?? "Unknown"}',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Age: ${birthDateTime != null ? calculateAge(birthDateTime) : "Unknown"}',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Phone Number: ${patientUserModel?.phoneNumber ?? "Unknown"}',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionTimeContentComponent() {
    DateTime startTime = parseTime(appointment.startAt);
    DateTime endTime = parseTime(appointment.endAt);
    Duration sessionDuration = endTime.difference(startTime);
    String sessionDurationString;
    if (sessionDuration.inMinutes.remainder(60) == 0) {
      sessionDurationString = '${sessionDuration.inHours}h';
    } else {
      sessionDurationString = '${sessionDuration.inHours}h ${sessionDuration.inMinutes.remainder(60)}m';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Session time',
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 15.57,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            sessionDurationString,
            textAlign: TextAlign.center,
            style: GoogleFonts.redHatDisplay(
              color: Color(0xFF090F47),
              fontSize: 18.43,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionContentComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Option',
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 15.57,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              appointment.optionPicked["name"],
              textAlign: TextAlign.end,
              style: GoogleFonts.redHatDisplay(
                color: Color(0xFF090F47),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateContentComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rate',
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 15.57,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '\$ ${appointment.optionPicked["price"]}',
            textAlign: TextAlign.center,
            style: GoogleFonts.redHatDisplay(
              color: Color(0xFF090F47),
              fontSize: 18.43,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.35,
            ),
          ),
        ],
      ),
    );
  }

  Padding _patientSymptomsComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patient's symptoms",
            style: GoogleFonts.openSans(
              color: Color(0xFF090F47),
              fontSize: 15.57,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          _symptomsContentComponent(),
        ],
      ),
    );
  }

  Widget _symptomsContentComponent() {
    List<String>? symptoms = Get.find<FirebaseFirestoreService>().getUserModel?.symptoms;
    if (symptoms == null || symptoms.isEmpty) {
      return SizedBox.shrink();
    }

    List<Widget> symptomsWidgets = [];

    for (String symptom in symptoms) {
      final painType = Constants.painTypes.firstWhere(
        (type) => type.title == symptom,
        orElse: () => PainType("", ""),
      );

      if (painType.title.isNotEmpty && painType.imagePath.isNotEmpty) {
        symptomsWidgets.add(
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 35.48,
                    height: 35.48,
                    child: ClipOval(
                      child: Image.asset(
                        painType.imagePath,
                        fit: BoxFit.cover,
                        width: 35.48,
                        height: 35.48,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  painType.title,
                  style: GoogleFonts.openSans(
                    color: Color(0xFF393938),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: symptomsWidgets,
      ),
    );
  }

  Container _doctorImageWithNameAndSpecialityComponent(UserModel doctorUserModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22),
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.70, color: Color(0x26090F47)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 48,
              height: 48,
              child: CachedNetworkImage(
                imageUrl: doctorUserModel.profileImageUrl ?? "",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) {
                  return SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: shimmerComponent(
                        double.infinity,
                        double.infinity,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13),
                        ),
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Center(
                    child: CircleAvatar(
                      backgroundColor: DocareTheme.apple,
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 24),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctorUserModel.name ?? "Unknown",
                style: GoogleFonts.poppins(
                  color: Color(0xFF0D1B34),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doctorUserModel.medicalSpeciality ?? "Unknown",
                style: GoogleFonts.poppins(
                  color: Color(0xFF8696BB),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
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
}
