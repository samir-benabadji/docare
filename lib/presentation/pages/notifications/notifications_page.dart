import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../business_logic/models/appointment_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../../core/assets.gen.dart';
import 'notifications_appointment_preview_page.dart';
import 'notifications_controller.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      init: NotificationsController(),
      builder: (notificationsController) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBarComponent(),
                  SizedBox(height: 16),
                  _notificationsTitleComponent(),
                  SizedBox(height: 30),
                  _notificationsMainContentComponent(notificationsController),
                  SizedBox(height: 27),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _notificationsMainContentComponent(NotificationsController notificationsController) {
    final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
    return StreamBuilder<List<AppointmentModel>>(
      stream: notificationsController.appointmentsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              SizedBox(height: 48),
              _noNotificationsComponent("There are no Notifications yet "),
            ],
          );
        } else {
          return Column(
            children: [
              for (var appointment in snapshot.data!)
                _notificationMainContentComponent(appointment, notificationsController),
            ],
          );
        }
      },
    );
  }

  Widget _notificationMainContentComponent(
    AppointmentModel appointment,
    NotificationsController notificationsController,
  ) {
    if (appointment.appointmentStatus == "PENDING") return SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        notificationsController.getDoctorUserModel(appointment.doctorId);
        Get.to(
          () => NotificationsApointmentPreviewPage(
            appointment: appointment,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3FD2D2D2),
              blurRadius: 4,
              offset: Offset(-1, 0),
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              getAppointmentStatusIconPath(appointment.appointmentStatus),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getAppointmentStatusTitle(appointment.appointmentStatus),
                    style: GoogleFonts.poppins(
                      color: Color(0xFF0D1B34),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    getAppointmentStatusDescription(appointment),
                    style: GoogleFonts.poppins(
                      color: Color(0xFF8696BB),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getAppointmentStatusTitle(String status) {
    switch (status) {
      case 'UPCOMING':
        return 'Appointment Confirmed';
      case 'CANCELED':
        return 'Appointment Canceled';
      case 'REJECTED':
        return 'Rejected Appointment';
      default:
        return 'Unknown';
    }
  }

  String getAppointmentStatusIconPath(String status) {
    switch (status) {
      case 'UPCOMING':
        return Assets.icons.notifications.notificationUpcoming.path;
      case 'CANCELED':
        return Assets.icons.notifications.notificationCanceled.path;
      case 'REJECTED':
        return Assets.icons.notifications.notificationRejected.path;
      default:
        return 'Unknown';
    }
  }

  String getAppointmentStatusDescription(AppointmentModel appointment) {
    switch (appointment.appointmentStatus) {
      case 'UPCOMING':
        return 'Your appointment has been confirmed by doctor ${appointment.doctorName}.';
      case 'CANCELED':
        return 'Unfortunately, your appointment has been canceled.';
      case 'REJECTED':
        return 'Your appointment has been rejected by doctor ${appointment.doctorName}.';
      default:
        return 'Unknown';
    }
  }

  Widget _noNotificationsComponent(String title) {
    return Column(
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: GoogleFonts.rubik(
              color: Color(0xFF090F47),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.31,
            ),
          ),
        if (title.isNotEmpty) SizedBox(height: 25),
        Image.asset(
          Assets.images.noNotifications.path,
          fit: BoxFit.cover,
          cacheHeight: 250,
          cacheWidth: 250,
        ),
      ],
    );
  }

  Widget _notificationsTitleComponent() {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
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
            "Notification",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 48,
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
