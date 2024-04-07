import 'package:cached_network_image/cached_network_image.dart';
import 'package:docare/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../business_logic/models/user_model.dart';
import '../../widgets/utils.dart';

import 'discovery_controller.dart';

class DiscoverySpecialistDoctorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiscoveryController>(
      builder: (discoveryController) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _topBarComponent(),
                  SizedBox(height: 10),
                  _mainSpecialistDoctorsComponent(discoveryController),
                  SizedBox(height: 27),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _mainSpecialistDoctorsComponent(DiscoveryController discoveryController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        children: [
          _specialistDoctorsTitleComponent(),
          SizedBox(height: 13),
          _specialistDoctorsContentComponent(discoveryController),
        ],
      ),
    );
  }

  Widget _specialistDoctorsTitleComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Get.context != null ? AppLocalizations.of(Get.context!)!.specialistDoctors : 'Specialist Doctors',
          style: GoogleFonts.inter(
            color: Color(0xFF090F47),
            fontSize: 15.45,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _topBarComponent() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 14,
        left: 17,
        right: 13,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFF1F4F7)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _specialistDoctorsContentComponent(DiscoveryController discoveryController) {
    return StreamBuilder<List<UserModel>>(
      stream: discoveryController.specialistDoctorsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(
            Get.context != null
                ? AppLocalizations.of(Get.context!)!.specialistDoctorsErrorMessage(snapshot.error.toString())
                : 'Error: ${snapshot.error}',
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(
            Get.context != null
                ? AppLocalizations.of(Get.context!)!.noDoctorsFoundWithThisSpeciality
                : 'No doctors found with this speciality',
          );
        } else {
          final doctors = snapshot.data!;
          return Container(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(13),
                            topRight: Radius.circular(13),
                          ),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(13),
                                  topRight: Radius.circular(13),
                                ),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 2.30,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: CachedNetworkImage(
                              imageUrl: doctor.profileImageUrl ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) {
                                return SizedBox(
                                  height: 130,
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
                        Container(
                          width: 130,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(13),
                                bottomRight: Radius.circular(13),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                doctor.name ??
                                    (Get.context != null
                                        ? AppLocalizations.of(Get.context!)!.noNameProvided
                                        : 'No name provided'),
                                style: GoogleFonts.inter(
                                  color: Color(0xFF090F47),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.40,
                                ),
                              ),
                              Text(
                                doctor.medicalSpeciality ??
                                    (Get.context != null ? AppLocalizations.of(Get.context!)!.unknown : 'Unknown'),
                                style: GoogleFonts.rubik(
                                  color: Color(0xFF090F47),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -0.14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
