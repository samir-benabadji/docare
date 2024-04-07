import 'package:cached_network_image/cached_network_image.dart';
import 'package:docare/presentation/pages/appointments/pending_appointments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../business_logic/models/appointment_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/theme.dart';
import '../../widgets/utils.dart';
import 'appointments_controller.dart';
import 'appointments_detail_for_doctor_page.dart';
import 'appointments_detail_for_patient_page.dart';
import 'canceled_appointments_page.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentsController>(
      init: AppointmentsController(),
      builder: (appointmentsController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _topBarComponent(),
                SizedBox(height: 6),
                _appointmentsTitleComponent(appointmentsController),
                SizedBox(height: 32),
                _appointmentsMainContent(appointmentsController),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _appointmentViewForDoctorComponent(
    AppointmentsController appointmentsController,
    AppointmentModel appointment,
  ) {
    DateTime appointmentDate = DateTime.fromMillisecondsSinceEpoch(appointment.appointmentTimeStamp);
    String formattedDate = DateFormat('EEEE, d MMMM').format(appointmentDate); // TODO: also show the year?
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: 8,
        right: 8,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0A5975A6),
            blurRadius: 20,
            offset: Offset(2, 12),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 48,
                  height: 48,
                  child: (appointment.patientProfileImageUrl != null && appointment.patientProfileImageUrl!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: appointment.patientProfileImageUrl!,
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
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.patientName ??
                        (Get.context != null ? AppLocalizations.of(Get.context!)!.unknown : "Unknown"),
                    style: GoogleFonts.poppins(
                      color: Color(0xFF0D1B34),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appointment.patientPhoneNumber ??
                        appointment.patientEmail ??
                        (Get.context != null ? AppLocalizations.of(Get.context!)!.unknown : "Unknown"),
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
          SizedBox(height: 20),
          Container(
            height: 1,
            width: Get.width,
            color: Color(0xffF5F5F5),
          ),
          SizedBox(height: 20),
          Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.home.miniCalendar.path,
                  ),
                  SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: GoogleFonts.poppins(
                      color: Color(0xFF8696BB),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.home.miniClock.path,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "${appointment.startAt.split(' ')[0]} - ${appointment.endAt.split(' ')[0]}",
                    style: GoogleFonts.poppins(
                      color: Color(0xFF8696BB),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              appointmentsController.getPatientUserModel(appointment.patientId);
              Get.to(
                () => AppointmentsDetailForDoctorPage(
                  appointment: appointment,
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: ShapeDecoration(
                color: Color(0x192AD495),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                Get.context != null ? AppLocalizations.of(Get.context!)!.detail : 'Detail',
                style: GoogleFonts.poppins(
                  color: Color(0xFF2AD495),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _appointmentViewForPatientComponent(
    AppointmentsController appointmentsController,
    AppointmentModel appointment,
  ) {
    DateTime appointmentDate = DateTime.fromMillisecondsSinceEpoch(appointment.appointmentTimeStamp);
    String formattedDate = DateFormat('EEEE, d MMMM').format(appointmentDate); // TODO: also show the year?
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: 8,
        right: 8,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0A5975A6),
            blurRadius: 20,
            offset: Offset(2, 12),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 48,
                  height: 48,
                  child: CachedNetworkImage(
                    imageUrl: appointment.doctorProfileImageUrl,
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
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.doctorName,
                    style: GoogleFonts.poppins(
                      color: Color(0xFF0D1B34),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appointment.doctorSpecialty,
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
          SizedBox(height: 20),
          Container(
            height: 1,
            width: Get.width,
            color: Color(0xffF5F5F5),
          ),
          SizedBox(height: 20),
          Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.home.miniCalendar.path,
                  ),
                  SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: GoogleFonts.poppins(
                      color: Color(0xFF8696BB),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.home.miniClock.path,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "${appointment.startAt.split(' ')[0]} - ${appointment.endAt.split(' ')[0]}",
                    style: GoogleFonts.poppins(
                      color: Color(0xFF8696BB),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              appointmentsController.getDoctorUserModel(appointment.doctorId);
              Get.to(
                () => AppointmentsDetailForPatientPage(
                  appointment: appointment,
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: ShapeDecoration(
                color: Color(0x192AD495),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                Get.context != null ? AppLocalizations.of(Get.context!)!.detail : 'Detail',
                style: GoogleFonts.poppins(
                  color: Color(0xFF2AD495),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _searchTextField() {
    return Container(
      width: Get.width,
      height: 46,
      padding: EdgeInsets.only(left: 16, right: 16),
      margin: const EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 3.50,
            offset: Offset(4, 2),
            spreadRadius: 0,
          )
        ],
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.40,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xFF858D9D),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: TextField(
        // controller: searchController.textEditingController,
        onEditingComplete: () {
          //   searchController.onSearch();
        },
        style: TextStyle(
          color: Color(0xFF667085),
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          suffixIcon: /* searchController.showXButton
              ? GestureDetector(
                  onTap: () {
                   // searchController.textEditingController.text = "";
                  //  searchController.onSearch();
                  },
                  child: SvgPicture.asset(
                    Assets.icons.x.path,
                    fit: BoxFit.scaleDown,
                    height: 30,
                    width: 30,
                    color: Color(0xFF667085),
                  ),
                )
              :*/
              null,
          //  suffixIconConstraints: searchController.showXButton ? BoxConstraints(minWidth: 0, minHeight: 0) : null,
          prefixIcon: GestureDetector(
            onTap: () {
              //  searchController.onSearch();
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.icons.home.largeSearchSign.path,
                  ),
                  SizedBox(width: 21)
                ],
              ),
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          hintText: Get.context != null ? AppLocalizations.of(Get.context!)!.search : 'Search...',
          hintStyle: GoogleFonts.openSans(
            color: Color(0xFF858D9D),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
        ),
      ),
    );
  }

  Widget _appointmentsTitleComponent(AppointmentsController appointmentsController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Text(
            Get.context != null ? AppLocalizations.of(Get.context!)!.myAppointments : "My appointments",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Canceled appointements',
                child: Text(
                  Get.context != null
                      ? AppLocalizations.of(Get.context!)!.canceledAppointements
                      : 'Canceled appointements',
                  style: GoogleFonts.poppins(
                    color: Color(0xFF202528),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'Pending appointements',
                child: Text(
                  Get.context != null
                      ? AppLocalizations.of(Get.context!)!.pendingAppointements
                      : 'Pending appointements',
                  style: GoogleFonts.poppins(
                    color: Color(0xFF202528),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
            onSelected: (String value) async {
              if (value == 'Canceled appointements') {
                appointmentsController.getDoctorCanceledAppointments();
                Get.to(() => CanceledAppointmentsPage());
              } else if (value == 'Pending appointements') {
                appointmentsController.getDoctorPendingAppointments();
                Get.to(() => PendingAppointmentsPage());
              }
            },
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Container _toggleButtonComponent(AppointmentsController appointmentsController) {
    final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
    String historyOrPendingCategory = 'Pending';
    if (_firebaseFirestoreService.getUserModel != null) {
      historyOrPendingCategory = _firebaseFirestoreService.getUserModel!.userType == 2 ? 'Pending' : "History";
    }
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
              appointmentsController.appointmentCategory = "Upcoming";
              appointmentsController.update();
            },
            child: Container(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                width: 136.17,
                decoration: appointmentsController.appointmentCategory == "Upcoming"
                    ? ShapeDecoration(
                        color: Color(0xFF3BC090),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38.78),
                        ),
                      )
                    : null,
                child: Text(
                  Get.context != null ? AppLocalizations.of(Get.context!)!.upcoming : 'Upcoming',
                  style: GoogleFonts.poppins(
                    color: appointmentsController.appointmentCategory == "Upcoming" ? Colors.white : Color(0xFF3BC090),
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
              appointmentsController.appointmentCategory = historyOrPendingCategory;
              appointmentsController.update();
            },
            child: Container(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                width: 136.17,
                decoration: appointmentsController.appointmentCategory == historyOrPendingCategory
                    ? ShapeDecoration(
                        color: Color(0xFF3BC090),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38.78),
                        ),
                      )
                    : null,
                child: Text(
                  historyOrPendingCategory == 'Pending'
                      ? (Get.context != null ? AppLocalizations.of(Get.context!)!.pending : 'Pending')
                      : (Get.context != null ? AppLocalizations.of(Get.context!)!.history : 'history'),
                  style: GoogleFonts.poppins(
                    color: appointmentsController.appointmentCategory == historyOrPendingCategory
                        ? Colors.white
                        : Color(0xFF3BC090),
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

  Widget _appointmentsMainContent(AppointmentsController appointmentsController) {
    final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
    return StreamBuilder<List<AppointmentModel>>(
      stream: appointmentsController.appointmentsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
            Get.context != null
                ? AppLocalizations.of(Get.context!)!.appointmentsStreamError(snapshot.error.toString())
                : 'Error: ${snapshot.error}',
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              SizedBox(height: 48),
              _noAppointmentsComponent(Get.context != null
                  ? AppLocalizations.of(Get.context!)!.appointmentPageEmpty
                  : "Appointment Page is currently empty"),
            ],
          );
        } else {
          // Filter logic between a patient and a doctor
          final filteredAppointments =
              appointmentsController.filteringDataLogic(snapshot.data!, appointmentsController.appointmentCategory);

          if (filteredAppointments.isEmpty) return _noAppointmentsCategoryComponent(appointmentsController);

          if (_firebaseFirestoreService.getUserModel != null) {
            return _firebaseFirestoreService.getUserModel!.userType == 2
                ? _displayComponentForPatient(appointmentsController, filteredAppointments)
                : _displayComponentForDoctor(appointmentsController, filteredAppointments);
          } else
            return SizedBox.shrink();
        }
      },
    );
  }

  Widget _displayComponentForDoctor(
    AppointmentsController appointmentsController,
    List<AppointmentModel> filteredAppointments,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _toggleButtonComponent(appointmentsController),
            SizedBox(height: 5),
            _searchTextField(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 19, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final appointment in filteredAppointments)
                    Padding(
                      padding: EdgeInsets.only(bottom: 19),
                      child: _appointmentViewForDoctorComponent(appointmentsController, appointment),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayComponentForPatient(
    AppointmentsController appointmentsController,
    List<AppointmentModel> filteredAppointments,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _toggleButtonComponent(appointmentsController),
            SizedBox(height: 5),
            _searchTextField(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 19, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final appointment in filteredAppointments)
                    Padding(
                      padding: EdgeInsets.only(bottom: 19),
                      child: _appointmentViewForPatientComponent(appointmentsController, appointment),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noAppointmentsCategoryComponent(AppointmentsController appointmentsController) {
    return Column(
      children: [
        _toggleButtonComponent(appointmentsController),
        SizedBox(height: 32),
        _noAppointmentsComponent(
          appointmentsController.appointmentCategory == "Upcoming"
              ? (Get.context != null
                  ? AppLocalizations.of(Get.context!)!.thereAreNoUpcoming
                  : 'There are no upcoming appointments')
              : appointmentsController.appointmentCategory == "History"
                  ? (Get.context != null ? AppLocalizations.of(Get.context!)!.noHistoryYet : "No history yet")
                  : (Get.context != null
                      ? AppLocalizations.of(Get.context!)!.noPendingAppointments
                      : "There are no pending appointments"),
        ),
      ],
    );
  }

  Widget _noAppointmentsComponent(String title) {
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
          Assets.images.appointments.noAppointment.path,
          fit: BoxFit.cover,
          cacheHeight: 250,
          cacheWidth: 250,
        ),
      ],
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
