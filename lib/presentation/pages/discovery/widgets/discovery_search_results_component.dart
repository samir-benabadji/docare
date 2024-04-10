import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../business_logic/models/user_model.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/theme.dart';
import '../../../widgets/utils.dart';
import '../../doctorProfile/doctor_profile_page.dart';
import '../discovery_controller.dart';

class DiscoverySearchResultsComponent extends StatelessWidget {
  const DiscoverySearchResultsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiscoveryController>(
      builder: (discoveryController) {
        return StreamBuilder<List<UserModel>>(
          stream: discoveryController.searchedDoctorsStream.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text(
                Get.context != null
                    ? AppLocalizations.of(Get.context!)!.searchedDoctorsErrorMessage(snapshot.error.toString())
                    : 'Error: ${snapshot.error}',
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text(
                Get.context != null
                    ? AppLocalizations.of(Get.context!)!.noDoctorsFoundWithThatName
                    : 'No doctors found with that name',
              );
            } else {
              final doctors = discoveryController.currentSelectedSpeciality.isNotEmpty
                  ? snapshot.data!
                      .where((doctor) => doctor.medicalSpeciality == discoveryController.currentSelectedSpeciality)
                      .toList()
                  : snapshot.data!;

              return Column(
                children: [
                  _searchSpecialityOptionsComponent(discoveryController),
                  Divider(
                    color: Colors.black.withOpacity(0.15),
                    thickness: 1.5,
                  ),
                  if (doctors.isEmpty)
                    Text(
                      Get.context != null
                          ? AppLocalizations.of(Get.context!)!.noDoctorsFoundWithThisSpeciality
                          : "No doctors found with this speciality",
                    ),
                  if (doctors.isNotEmpty)
                    Container(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => DoctorProfilePage(
                                  userModel: doctor,
                                ),
                              );
                            },
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
                                              (Get.context != null
                                                  ? AppLocalizations.of(Get.context!)!.unknown
                                                  : 'Unknown'),
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
                    ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _searchSpecialityOptionsComponent(DiscoveryController discoveryController) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: Constants.specialityTypes.map((speciality) {
          return GestureDetector(
            onTap: () {
              discoveryController.currentSelectedSpeciality = speciality.title;
              discoveryController.update();
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: discoveryController.currentSelectedSpeciality == speciality.title
                    ? DocareTheme.apple
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.71, color: DocareTheme.apple),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    speciality.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
