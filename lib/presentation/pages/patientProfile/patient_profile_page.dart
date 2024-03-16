import 'package:cached_network_image/cached_network_image.dart';
import 'package:docare/presentation/pages/patientProfile/patient_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/theme.dart';
import '../../widgets/utils.dart';

class PatientProfilePage extends StatelessWidget {
  final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientProfileController>(
      init: PatientProfileController(),
      builder: (patientProfileController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _topBarComponent(),
                SizedBox(height: 6),
                _patientProfileTitleComponent(),
                SizedBox(height: 32),
                _imagePlusNameComponents(patientProfileController),
                SizedBox(height: 39),
                _patientProfileSettingsComponent(context, patientProfileController),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _patientProfileSettingsComponent(BuildContext context, PatientProfileController patientProfileController) {
    return Padding(
      padding: const EdgeInsets.only(left: 27, right: 24),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: SvgPicture.asset(
              Assets.icons.profile.notifications.path,
            ),
            title: Text('Notifications'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset(
              Assets.icons.profile.lock.path,
            ),
            title: Text('Security'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset(
              Assets.icons.profile.eyeOpen.path,
            ),
            title: Text('Appearance'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset(
              Assets.icons.profile.questionMark.path,
            ),
            title: Text('Security'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset(
              Assets.icons.profile.twoUsers.path,
            ),
            title: Text('Invite Friends'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset(
              Assets.icons.profile.logout.path,
            ),
            title: Text('Logout'),
            onTap: () {
              showLogoutConfirmation(context, patientProfileController);
            },
          ),
        ],
      ),
    );
  }

  void showLogoutConfirmation(BuildContext context, PatientProfileController patientProfileController) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(27),
          topRight: Radius.circular(27),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            left: 32,
            right: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 32),
              Icon(
                Icons.logout,
                size: 43,
                color: DocareTheme.apple,
              ),
              SizedBox(height: 29),
              Text(
                'Are you sure you want to logout?',
                style: GoogleFonts.poppins(
                  color: Color(0xFF090F47),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFF3BC090)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          color: Color(0xFF3BC090),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      patientProfileController.logout();

                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(0xFF3BC090),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Yes, logout',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
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

  Widget _patientProfileTitleComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Text(
            "My Profile",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SvgPicture.asset(
            Assets.icons.edit.path,
            height: 20,
            width: 20,
          ),
        ],
      ),
    );
  }

  Padding _imagePlusNameComponents(PatientProfileController patientProfileController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: Row(
        children: [
          _userImageComponent(patientProfileController),
          SizedBox(width: 32),
          _userNameComponent(patientProfileController),
        ],
      ),
    );
  }

  Widget _userNameComponent(PatientProfileController patientProfileController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _firebaseFirestoreService.getUserModel?.name ?? "Unknown",
          style: GoogleFonts.plusJakartaSans(
            color: Color(0xFF090F47),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 3),
        Text(
          _firebaseFirestoreService.getUserModel?.email ?? "Unknown",
          style: GoogleFonts.poppins(
            color: Color(0xFF677294),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _userImageComponent(PatientProfileController onboardingController) {
    return Container(
      width: 88,
      height: 88,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: _firebaseFirestoreService.getUserModel?.profileImageUrl ?? "",
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
    );
  }
}
