import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../business_logic/models/appointment_model.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/theme.dart';
import '../../widgets/utils.dart';
import 'history_appointment_details_page.dart';
import 'history_controller.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
      init: HistoryController(),
      builder: (historyController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _topBarComponent(),
                SizedBox(height: 6),
                _historyAppointmentsTitleComponent(),
                SizedBox(height: 4),
                _historyAppointmentsMainContent(historyController),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _historyAppointmentComponent(HistoryController historyController, AppointmentModel appointment) {
    DateTime appointmentDate = DateTime.fromMillisecondsSinceEpoch(appointment.appointmentTimeStamp);
    String formattedDate = DateFormat('EEEE, d MMMM').format(appointmentDate); // TODO: also show the year?
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
          ),
          child: Text(
            formattedDate,
            style: GoogleFonts.poppins(
              color: Color(0xFF677294),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 17),
        GestureDetector(
          onTap: () {
            historyController.getDoctorUserModel(appointment.doctorId);
            Get.to(
              () => HistoryAppointmentDetailsPage(
                appointment: appointment,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 16,
              left: 24,
              right: 24,
            ),
            padding: const EdgeInsets.only(left: 11, top: 9, bottom: 9),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.50,
                  color: Colors.black.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
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
          ),
        ),
      ],
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

  Widget _historyAppointmentsTitleComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Text(
            Get.context != null ? AppLocalizations.of(Get.context!)!.history : "History",
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

  Widget _historyAppointmentsMainContent(HistoryController historyController) {
    return StreamBuilder<List<AppointmentModel>>(
      stream: historyController.appointmentsStream.stream,
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
                ? AppLocalizations.of(Get.context!)!.historyAppointmentsStreamError(snapshot.error.toString())
                : 'Error: ${snapshot.error}',
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _noHistoryAppointmentsComponent(
            Get.context != null ? AppLocalizations.of(Get.context!)!.thereIsNoHistoryYet : "There is no history yet.",
          );
        } else {
          final appointments = snapshot.data!;
          final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

          // Filtering appointments based on appointmentTimeStamp
          final filteredAppointments = appointments.where((appointment) {
            return appointment.appointmentTimeStamp < currentTimestamp;
          }).toList();

          if (filteredAppointments.isEmpty)
            return _noHistoryAppointmentsComponent(
              Get.context != null ? AppLocalizations.of(Get.context!)!.thereIsNoHistoryYet : "There is no history yet.",
            );

          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _searchTextField(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final appointment in filteredAppointments)
                        Padding(
                          padding: EdgeInsets.only(bottom: 19),
                          child: _historyAppointmentComponent(historyController, appointment),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _noHistoryAppointmentsComponent(String title) {
    return Column(
      children: [
        SizedBox(height: 48),
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
          Assets.images.history.noHistory.path,
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
