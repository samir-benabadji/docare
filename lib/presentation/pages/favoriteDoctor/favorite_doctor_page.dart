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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _noFavoriteDoctorsComponent();
        } else {
          final doctors = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return _doctorCardComponent(doctor);
              },
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
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 130,
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: CachedNetworkImage(
                imageUrl: doctor.profileImageUrl ?? "",
                fit: BoxFit.cover,
                width: 130,
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
                children: [
                  Text(
                    doctor.name ?? 'No name provided',
                    style: GoogleFonts.inter(
                      color: Color(0xFF090F47),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    doctor.medicalSpeciality ?? 'Unknown',
                    style: GoogleFonts.rubik(
                      color: Color(0xFF090F47),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
