import 'package:cached_network_image/cached_network_image.dart';
import 'package:docare/business_logic/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../business_logic/models/pain_model.dart';
import '../../../business_logic/models/speciality_model.dart';
import '../../../core/constants/constants.dart';
import '../../../core/constants/theme.dart';
import '../../widgets/utils.dart';

class DoctorProfilePage extends StatelessWidget {
  final UserModel userModel;
  DoctorProfilePage({required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBarComponent(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Row(
                children: [
                  _doctorImageComponent(),
                  SizedBox(width: 27),
                  _doctorNameAndSpecialityComponent(),
                ],
              ),
            ),
            SizedBox(height: 25),
            _doctorConsultationDurationComponent(),
            SizedBox(height: 26),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _specialityTitleComponent(),
                  SizedBox(height: 17),
                  _specialityContentComponent(),
                ],
              ),
            ),
            SizedBox(height: 24),
            if (userModel.symptoms != null) _symptomComponent(),
            SizedBox(height: 24),
            if (userModel.options != null) _doctorOptionsComponent(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Padding _doctorOptionsComponent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 6,
        runSpacing: 11,
        children: userModel.options!.map(
          (option) {
            return Container(
              padding: EdgeInsets.all(7),
              decoration: ShapeDecoration(
                color: Color(0xFFFEFCF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.58),
                ),
              ),
              child: Text(
                option,
                style: GoogleFonts.openSans(
                  color: Color(0xFF090F47),
                  fontSize: 14.00,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.27,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _symptomComponent() {
    if (userModel.symptoms == null || userModel.symptoms!.isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: userModel.symptoms!.map((symptom) {
            final painType = Constants.painTypes.firstWhere(
              (type) => type.title == symptom,
              orElse: () => PainType("", ""),
            );
            if (painType.title.isNotEmpty && painType.imagePath.isNotEmpty) {
              return Container(
                margin: EdgeInsets.only(right: 52),
                child: Row(
                  children: [
                    Container(
                      width: 35.48,
                      height: 35.48,
                      child: Image.asset(
                        painType.imagePath,
                        fit: BoxFit.cover,
                        width: 35.48,
                        height: 35.48,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      painType.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xFF090F47),
                        fontSize: 14.00,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget _specialityContentComponent() {
    if (userModel.medicalSpeciality == null || userModel.medicalSpeciality!.isEmpty) {
      return SizedBox.shrink();
    }

    final specialityType = Constants.specialityTypes.firstWhere(
      (type) => type.title == userModel.medicalSpeciality,
      orElse: () => SpecialityType("", ""),
    );

    if (specialityType.title.isNotEmpty && specialityType.imagePath.isNotEmpty) {
      return Row(
        children: [
          ClipOval(
            child: Container(
              padding: EdgeInsets.all(13),
              width: 69,
              height: 69,
              decoration: BoxDecoration(
                color: Color(0xffFEFCF7),
                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.inner,
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: Offset(-2, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  specialityType.imagePath,
                  fit: BoxFit.cover,
                  width: 35.48,
                  height: 35.48,
                ),
              ),
            ),
          ),
          SizedBox(width: 6),
          Text(
            specialityType.title,
            style: GoogleFonts.openSans(
              color: Color(0xFF393938),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Text _specialityTitleComponent() {
    return Text(
      'Speciality',
      style: GoogleFonts.openSans(
        color: Color(0xFF090F47),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _doctorConsultationDurationComponent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.only(top: 6, left: 12, bottom: 6),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Color(0xff34C759).withOpacity(0.04),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Color(0xff34C759).withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          'The duration of the consultation is 1 hour.',
          style: GoogleFonts.plusJakartaSans(
            color: Color(0xFF34C759),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Expanded _doctorNameAndSpecialityComponent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userModel.name ?? "Unknown",
            style: GoogleFonts.openSans(
              color: Color(0xFF393938),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            userModel.medicalSpeciality ?? "Unknown",
            style: GoogleFonts.openSans(
              color: Color(0xFF393938),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorImageComponent() {
    return ClipOval(
      child: Container(
        height: 110,
        width: 110,
        child: CachedNetworkImage(
          imageUrl: userModel.profileImageUrl ?? "",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) {
            return SizedBox(
              height: 110,
              child: Center(
                child: shimmerComponent(
                  110,
                  110,
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

  AppBar _appBarComponent(BuildContext context) {
    return AppBar(
      leading: IconButton(
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
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
      ],
      centerTitle: true,
      title: Text(
        userModel.name ?? "Unknown",
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
