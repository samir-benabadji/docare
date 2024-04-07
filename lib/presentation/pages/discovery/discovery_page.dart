import 'package:cached_network_image/cached_network_image.dart';
import 'package:docare/core/constants/theme.dart';
import 'package:docare/presentation/pages/discovery/widgets/discovery_search_results_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/constants.dart';
import '../../widgets/utils.dart';
import '../doctorProfile/doctor_profile_page.dart';
import '../favoriteDoctor/favorite_doctor_page.dart';
import '../notifications/notifications_page.dart';
import 'discovery_controller.dart';
import 'discovery_specialist_doctors_page.dart';

class DiscoveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiscoveryController>(
      init: DiscoveryController(),
      builder: (discoveryController) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _topBarComponent(),
                  SizedBox(height: 10),
                  _searchTextField(discoveryController),
                  SizedBox(height: 27),
                  discoveryController.textEditingSearchController.text.isEmpty
                      ? Column(
                          children: [
                            _mainSpecialistDoctorComponent(discoveryController),
                            SizedBox(height: 32),
                            _mainTopDoctorsComponent(discoveryController),
                          ],
                        )
                      : DiscoverySearchResultsComponent(),
                  SizedBox(height: 27),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _mainTopDoctorsComponent(DiscoveryController discoveryController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        children: [
          _topDoctorsTitleComponent(),
          SizedBox(height: 13),
          _topDoctorsContentComponent(discoveryController),
        ],
      ),
    );
  }

  Widget _topDoctorsTitleComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Get.context != null ? AppLocalizations.of(Get.context!)!.topDoctors : 'Top Doctors',
          style: GoogleFonts.inter(
            color: Color(0xFF090F47),
            fontSize: 15.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          Get.context != null ? AppLocalizations.of(Get.context!)!.seeAll : 'See all',
          style: GoogleFonts.inter(
            color: DocareTheme.apple,
            fontSize: 13.52,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.54,
          ),
        ),
      ],
    );
  }

  Padding _mainSpecialistDoctorComponent(DiscoveryController discoveryController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        children: [
          _specialistDoctorTitleComponent(),
          SizedBox(height: 27),
          _specialityGrid(discoveryController),
        ],
      ),
    );
  }

  Widget _specialityGrid(DiscoveryController discoveryController) {
    return SizedBox(
      height: 250,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: Constants.specialityTypes.length,
        itemBuilder: (BuildContext context, int index) {
          final speciality = Constants.specialityTypes[index];
          return GestureDetector(
            onTap: () async {
              discoveryController.clearSpecialistDoctorsStream();

              discoveryController.loadSpecialistDoctors(speciality.title);
              Get.to(() => DiscoverySpecialistDoctorsPage());
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFEFCF7),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(1, 0),
                    blurRadius: 4,
                    spreadRadius: 0,
                    color: Colors.black.withOpacity(0.25),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    speciality.imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                  Text(
                    speciality.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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

  Widget _specialistDoctorTitleComponent() {
    return Row(
      children: [
        Text(
          Get.context != null ? AppLocalizations.of(Get.context!)!.specialistDoctor : 'Specialist Doctor',
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
          SvgPicture.asset(
            Assets.icons.dOCARELogo.path,
          ),
          SizedBox(width: 2),
          SvgPicture.asset(
            Assets.icons.dOCAREText.path,
          ),
          //Always getting the live stream data
          //Obx(() => Text(Get.find<FirebaseFirestoreService>().userModel?.name ?? " unknown")),
          Spacer(),
          GestureDetector(
            onTap: () {
              Get.to(() => NotificationsPage());
            },
            child: Container(
              padding: EdgeInsets.all(6),
              color: Colors.transparent,
              child: SvgPicture.asset(
                Assets.icons.home.notifications.path,
              ),
            ),
          ),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              Get.to(() => FavoriteDoctorPage());
            },
            child: Container(
              padding: EdgeInsets.all(6),
              color: Colors.transparent,
              child: SvgPicture.asset(
                Assets.icons.home.heart.path,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchTextField(DiscoveryController discoveryController) {
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
        controller: discoveryController.textEditingSearchController,
        onEditingComplete: () {
          discoveryController.clearSearchedDoctorsStream();
          discoveryController.loadDoctorsByName();
          discoveryController.update();
        },
        style: TextStyle(
          color: Color(0xFF667085),
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          suffixIcon: discoveryController.showXButton
              ? GestureDetector(
                  onTap: () {
                    discoveryController.textEditingSearchController.text = "";
                    discoveryController.loadDoctorsByName();
                    discoveryController.update();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      Assets.icons.home.xClose.path,
                      fit: BoxFit.scaleDown,
                      height: 30,
                      width: 30,
                      color: Color(0xFF667085),
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: discoveryController.showXButton ? BoxConstraints(minWidth: 0, minHeight: 0) : null,
          prefixIcon: GestureDetector(
            onTap: () {
              discoveryController.clearSearchedDoctorsStream();
              discoveryController.loadDoctorsByName();
              discoveryController.update();
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
          hintText:
              Get.context != null ? AppLocalizations.of(Get.context!)!.searchForADoctor : 'Search for a doctor...',
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

  Widget _topDoctorsContentComponent(DiscoveryController discoveryController) {
    return StreamBuilder<List<UserModel>>(
      stream: discoveryController.topDoctorsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(
            Get.context != null
                ? AppLocalizations.of(Get.context!)!.topDoctorsErrorMessage(snapshot.error.toString())
                : 'Error: ${snapshot.error}',
          );
        } else if (!snapshot.hasData) {
          return Text(Get.context != null ? AppLocalizations.of(Get.context!)!.noDoctorsFound : 'No doctors found');
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
