import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../business_logic/models/user_model.dart';
import '../../../../core/assets.gen.dart';
import '../../../../core/constants/theme.dart';
import '../../../widgets/utils.dart';
import '../appointments_controller.dart';

void confirmDialogComponent(
  BuildContext context,
  AppointmentsController appointmentsController,
  String appointmentId,
  UserModel patientUserModel,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Color(0xff121212).withOpacity(0.05),
    builder: (BuildContext context) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: 81,
                      height: 81,
                      child: (patientUserModel.profileImageUrl != null && patientUserModel.profileImageUrl!.isNotEmpty)
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
                    patientUserModel.name ??
                        (Get.context != null ? AppLocalizations.of(Get.context!)!.unknown : "Unknown"),
                    style: GoogleFonts.poppins(
                      color: Color(0xFF090F47),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    Get.context != null
                        ? AppLocalizations.of(Get.context!)!.areYouSureConfirmAppointment
                        : 'Are you sure you want to Confirm this appointment for this patient',
                    style: GoogleFonts.openSans(
                      color: Color(0xFF090F47),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 41),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFF3E49),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F494949),
                                  blurRadius: 4.60,
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Text(
                              Get.context != null ? AppLocalizations.of(Get.context!)!.cancel : 'Cancel',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 18.55,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            appointmentsController.confirmAppointment(appointmentId);
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFF3BC090)),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F494949),
                                  blurRadius: 4.60,
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Text(
                              Get.context != null ? AppLocalizations.of(Get.context!)!.yesConfirm : 'Yes, Confirm',
                              style: GoogleFonts.rubik(
                                color: Color(0xFF3BC090),
                                fontSize: 18.55,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ],
      );
    },
  );
}

void rejectDialogComponent(
  BuildContext context,
  AppointmentsController appointmentsController,
  String appointmentId,
  UserModel patientUserModel,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Color(0xff121212).withOpacity(0.05),
    builder: (BuildContext context) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: 81,
                      height: 81,
                      child: (patientUserModel.profileImageUrl != null && patientUserModel.profileImageUrl!.isNotEmpty)
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
                    patientUserModel.name ??
                        (Get.context != null ? AppLocalizations.of(Get.context!)!.unknown : "Unknown"),
                    style: GoogleFonts.poppins(
                      color: Color(0xFF090F47),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    Get.context != null
                        ? AppLocalizations.of(Get.context!)!.areYouSureRejectAppointment
                        : 'Are you sure you want to Reject this appointment for this patient',
                    style: GoogleFonts.openSans(
                      color: Color(0xFF090F47),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 41),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFF3BC090)),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F494949),
                                  blurRadius: 4.60,
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Text(
                              Get.context != null ? AppLocalizations.of(Get.context!)!.cancel : 'Cancel',
                              style: GoogleFonts.rubik(
                                color: Color(0xFF3BC090),
                                fontSize: 18.55,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            appointmentsController.rejectAppointment(appointmentId);
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFF3E49),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F494949),
                                  blurRadius: 4.60,
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Text(
                              Get.context != null ? AppLocalizations.of(Get.context!)!.yesReject : 'Yes, Reject',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 18.55,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ],
      );
    },
  );
}
