import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../core/assets.gen.dart';
import '../../../core/constants/theme.dart';
import '../../widgets/utils.dart';
import 'favorite_doctor_controller.dart';

class FavoriteDoctorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteDoctorController>(
      init: FavoriteDoctorController(),
      builder: (discoveryController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _topBarComponent(),
                SizedBox(height: 6),
                _favoriteDoctorsTitleComponent(),
                _topDoctorsContentComponent(discoveryController),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _favoriteDoctorsTitleComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              color: Colors.transparent,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
            onPressed: () => Get.back(),
          ),
          Text(
            "Favorite Doctor",
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

  Widget _topDoctorsContentComponent(FavoriteDoctorController favoriteDoctorController) {
    return StreamBuilder<List<UserModel>>(
      stream: favoriteDoctorController.favoriteDoctorsStream.stream,
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
          return _noFavoriteDoctorsComponent();
        } else {
          final doctors = snapshot.data!;
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 19, vertical: 32),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 19,
                  mainAxisSpacing: 19,
                ),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return _doctorCardComponent(doctor);
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _noFavoriteDoctorsComponent() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Favorites Yet?',
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              color: Color(0xFF2E3360),
              fontSize: 20.53,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 42),
          Image.asset(
            Assets.icons.home.magnifier.path,
            fit: BoxFit.cover,
            width: 185,
            height: 185,
          ),
          SizedBox(height: 42),
          Text(
            'Discover Your Favorite Doctor Now!',
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              color: Color(0xFF090F47),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 14,
              ),
              decoration: ShapeDecoration(
                color: Color(0xFF2E3360),
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
                'Discover Now !',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 18.55,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.35,
                ),
              ),
            ),
          ),
          SizedBox(height: 42),
        ],
      ),
    );
  }

  Widget _doctorCardComponent(UserModel doctor) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: doctor.profileImageUrl ?? "",
                    fit: BoxFit.cover,
                    height: 130,
                    placeholder: (context, url) => shimmerComponent(130, 130),
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: DocareTheme.apple,
                      child: Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(13),
                      bottomRight: Radius.circular(13),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        doctor.name ?? 'No name provided',
                        style: GoogleFonts.inter(
                          color: Color(0xFF090F47),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        doctor.medicalSpeciality ?? 'Unknown',
                        style: GoogleFonts.rubik(
                          color: Color(0xFF090F47),
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              if (Get.context != null) {
                print('hey hey');
                _showConfirmationDialog(Get.context!, doctor);
              }
            },
            child: Image.asset(
              Assets.icons.home.heartWithShadow.path,
              fit: BoxFit.cover,
              height: 26,
              width: 26,
            ),
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

  void _showConfirmationDialog(BuildContext context, UserModel doctor) {
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
              content: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    padding: const EdgeInsets.only(left: 12, right: 14, top: 12, bottom: 16),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 1.87,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(13),
                                      topRight: Radius.circular(13),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: doctor.profileImageUrl ?? "",
                                      fit: BoxFit.cover,
                                      height: 130,
                                      placeholder: (context, url) => shimmerComponent(130, 130),
                                      errorWidget: (context, url, error) => CircleAvatar(
                                        backgroundColor: DocareTheme.apple,
                                        child: Icon(Icons.broken_image, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(13),
                                        bottomRight: Radius.circular(13),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          doctor.name ?? 'No name provided',
                                          style: GoogleFonts.inter(
                                            color: Color(0xFF090F47),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          doctor.medicalSpeciality ?? 'Unknown',
                                          style: GoogleFonts.rubik(
                                            color: Color(0xFF090F47),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Are you sure you want to remove ${doctor.name} from your favorites list?",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Color(0xFF090F47),
                                  fontSize: 14.00,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
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
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1.23, color: Color(0xFF090F47)),
                                      borderRadius: BorderRadius.circular(8.93),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x3F494949),
                                        blurRadius: 2.28,
                                        offset: Offset(0, 0.50),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.rubik(
                                      color: Color(0xFF090F47),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF090F47),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.93),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0xff090F47),
                                        blurRadius: 2.28,
                                        offset: Offset(0, 0.50),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    'Yes, Remove',
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.17,
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
                  Positioned(
                    right: 35,
                    top: 7.5,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          Assets.icons.home.xClose.path,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ],
        );
      },
    );
  }
}
