import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docare/business_logic/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../business_logic/models/appointment_model.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/theme.dart';
import '../../widgets/utils.dart';
import 'appointments_controller.dart';
import 'widgets/utils.dart';

class AppointmentsDetailForDoctorPage extends StatelessWidget {
  final AppointmentModel appointment;
  AppointmentsDetailForDoctorPage({required this.appointment});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentsController>(
      builder: (appointmentsController) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _topBarComponent(appointmentsController),
                  SizedBox(height: 16),
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
            child: Container(
              height: 48,
              width: 48,
              color: Colors.transparent,
              child: SvgPicture.asset(
                Assets.icons.leftArrow.path,
                fit: BoxFit.scaleDown,
              ),
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
          SizedBox(),
        ],
      ),
    );
  }

  Widget _appointmentDetailsMainContent(AppointmentsController appointmentsController) {
    return StreamBuilder<UserModel?>(
      stream: appointmentsController.patientUserModelStream.stream,
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
          final patientUserModel = snapshot.data!;
          return _appointmentDetailsComponent(patientUserModel, appointmentsController);
        }
      },
    );
  }

  Widget _appointmentDetailsComponent(UserModel patientUserModel, AppointmentsController appointmentsController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _patientImageWithNameComponent(patientUserModel),
        SizedBox(height: 15),
        _customDividerComponent(),
        SizedBox(height: 8),
        _patientDetailsContentComponent(patientUserModel),
        SizedBox(height: 8),
        _customDividerComponent(),
        SizedBox(height: 8),
        _patientContactInformationContentComponent(patientUserModel),
        SizedBox(height: 8),
        _customDividerComponent(),
        SizedBox(height: 8),
        _optionContentComponent(),
        SizedBox(height: 8),
        _rateContentComponent(),
        SizedBox(height: 8),
        _sessionTimeContentComponent(),
        SizedBox(height: 8),
        _customDividerComponent(),
        SizedBox(height: 8),
        _patientProblemContentComponent(),
        SizedBox(height: 8),
        _customDividerComponent(),
        SizedBox(height: 8),
        _visitTimeContentComponent(),
        if (appointment.appointmentStatus == "PENDING") SizedBox(height: 28),
        if (appointment.appointmentStatus == "PENDING")
          _confirmRejectAppointmentButtonsComponent(appointmentsController, patientUserModel),
        SizedBox(height: 24)
      ],
    );
  }

  Padding _customDividerComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        color: Color(0xff677294).withOpacity(0.15),
        thickness: 1.5,
      ),
    );
  }

  Widget _confirmRejectAppointmentButtonsComponent(
    AppointmentsController appointmentsController,
    UserModel patientUserModel,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (Get.context != null)
                  rejectDialogComponent(
                    Get.context!,
                    appointmentsController,
                    appointment.id,
                    patientUserModel,
                  );
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: ShapeDecoration(
                  color: Color(0xA8FF4C38),
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
                  'Reject',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 16.86,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 9),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (Get.context != null)
                  confirmDialogComponent(
                    Get.context!,
                    appointmentsController,
                    appointment.id,
                    patientUserModel,
                  );
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: ShapeDecoration(
                  color: Color(0xC13BC090),
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
                  'Confirm',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 16.86,
                    fontWeight: FontWeight.w500,
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

  Widget _patientDetailsContentComponent(UserModel patientUserModel) {
    DateTime? birthDateTime;
    if (patientUserModel.birthDate != null) {
      Timestamp? birthTimestamp = patientUserModel.birthDate;
      if (birthTimestamp != null) birthDateTime = birthTimestamp.toDate();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patient's details",
            style: GoogleFonts.poppins(
              color: Color(0xFF090F47),
              fontSize: 15.57,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Age: ',
                  style: GoogleFonts.inter(
                    color: Color(0xFF090F47),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '${birthDateTime != null ? calculateAge(birthDateTime) : "Unknown"}',
                  style: GoogleFonts.openSans(
                    color: Color(0xFF090F47),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Gender: ',
                  style: GoogleFonts.inter(
                    color: Color(0xFF090F47),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '${patientUserModel.gender ?? "Unknown"}',
                  style: GoogleFonts.openSans(
                    color: Color(0xFF090F47),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _patientContactInformationContentComponent(UserModel patientUserModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact's Information",
            style: GoogleFonts.poppins(
              color: Color(0xFF090F47),
              fontSize: 15.57,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Phone Number: ',
                  style: GoogleFonts.inter(
                    color: Color(0xFF090F47),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '${patientUserModel.phoneNumber ?? "Unknown"}',
                  style: GoogleFonts.openSans(
                    color: Color(0xFF090F47),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Email: ',
                  style: GoogleFonts.inter(
                    color: Color(0xFF090F47),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '${patientUserModel.email}',
                  style: GoogleFonts.openSans(
                    color: Color(0xFF090F47),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
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

  Widget _patientProblemContentComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The problem of the patient',
            style: GoogleFonts.poppins(
              color: Color(0xFF677294),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: Get.width,
            padding: EdgeInsets.all(14),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.50, color: Color(0xFF3BC090)),
                borderRadius: BorderRadius.circular(17),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0xD1C7C7C7),
                  blurRadius: 6.40,
                  offset: Offset(2, 2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Text(
              appointment.patientProblem,
              style: GoogleFonts.poppins(
                color: Color(0xFF090F47),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _optionContentComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Option selected',
            style: GoogleFonts.poppins(
              color: Color(0xFF090F47),
              fontSize: 15.57,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Color(0xFF3BC090),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  ),
                  child: Text(
                    appointment.optionPicked["name"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 14.96,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _patientImageWithNameComponent(UserModel patientUserModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22),
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                ClipOval(
                  child: Container(
                    width: 81,
                    height: 81,
                    child:
                        (appointment.patientProfileImageUrl != null && appointment.patientProfileImageUrl!.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: patientUserModel.profileImageUrl ?? "",
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
                              )
                            : SvgPicture.asset(
                                Assets.icons.home.profileAvatar.path,
                              ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  patientUserModel.name ?? "Unknown",
                  style: GoogleFonts.poppins(
                    color: Color(0xFF090F47),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (appointment.appointmentStatus == "REJECTED")
                  Container(
                    margin: EdgeInsets.only(top: 28),
                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0x0AFF4C38),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0x66FF4C38),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'The appointement was ',
                            style: GoogleFonts.openSans(
                              color: Color(0xFFFF4C38),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'Rejected',
                            style: GoogleFonts.openSans(
                              color: Color(0xFFFF4C38),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (appointment.appointmentStatus == "UPCOMING")
                  Container(
                    margin: EdgeInsets.only(top: 28),
                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0x0A34C759),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0x6634C759),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'The appointement was accepted',
                            style: GoogleFonts.openSans(
                              color: Color(0xFF34C759),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (appointment.appointmentStatus == "PENDING")
                  Container(
                    margin: EdgeInsets.only(top: 28),
                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0x0AFF9634),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0x66FF9634),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'The appointement is currently in ',
                            style: GoogleFonts.openSans(
                              color: Color(0xFFFF9534),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'pending status..',
                            style: GoogleFonts.openSans(
                              color: Color(0xFFFF9534),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (appointment.appointmentStatus == "CANCELED")
                  Container(
                    margin: EdgeInsets.only(top: 28),
                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0x0AFF4C38),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0x66FF4C38),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'The appointement was ',
                            style: GoogleFonts.openSans(
                              color: Color(0xFFFF4C38),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'Cancleled',
                            style: GoogleFonts.openSans(
                              color: Color(0xFFFF4C38),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBarComponent(AppointmentsController appointmentsController) {
    DateTime appointmentDateTime = DateTime.fromMillisecondsSinceEpoch(appointment.appointmentTimeStamp);
    DateTime currentDateTime = DateTime.now();
    bool is24HoursAhead = appointmentDateTime.isAfter(currentDateTime.add(Duration(hours: 24)));
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
          if (appointment.appointmentStatus == "UPCOMING")
            GestureDetector(
              onTap: () {
                if (appointment.appointmentStatus == "CANCELED") return;
                if (is24HoursAhead) {
                  appointmentsController.cancelAppointment(appointment.id);
                } else {
                  showToast('You cannot cancel appointments within 24 hours of the scheduled time.');
                }
              },
              child: appointment.appointmentStatus == "CANCELED"
                  ? Text(
                      'Canceled',
                      style: GoogleFonts.openSans(
                        color: Color(0x66FF4C38),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : Text(
                      'Cancel',
                      style: GoogleFonts.openSans(
                        color: Color(0xFFFF4C38),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
