import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../core/assets.gen.dart';
import 'appointments_controller.dart';

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
                _appointmentsTitleComponent(),
                SizedBox(height: 32),
                _toggleButtonComponent(appointmentsController),
                SizedBox(height: 22),
                _searchTextField(),
                _appointmentComponent(),
                _appointmentsMainContent(appointmentsController),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _appointmentComponent() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: 24,
        right: 24,
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. Wissam Azrine',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF0D1B34),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dental Specialist',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.home.miniCalendar.path,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sunday, 12 June',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF8696BB),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.home.miniClock.path,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "11:00 - 12:00 AM",
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
          Container(
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
              'Detail',
              style: GoogleFonts.poppins(
                color: Color(0xFF2AD495),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.1,
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
          hintText: 'Search...',
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

  Widget _appointmentsTitleComponent() {
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
            "My appointments",
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

  Container _toggleButtonComponent(AppointmentsController appointmentsController) {
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
                  'Upcoming',
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
              appointmentsController.appointmentCategory = 'Past';
              appointmentsController.update();
            },
            child: Container(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                width: 136.17,
                decoration: appointmentsController.appointmentCategory == 'Past'
                    ? ShapeDecoration(
                        color: Color(0xFF3BC090),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38.78),
                        ),
                      )
                    : null,
                child: Text(
                  'Past',
                  style: GoogleFonts.poppins(
                    color: appointmentsController.appointmentCategory == 'Past' ? Colors.white : Color(0xFF3BC090),
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
    return StreamBuilder<List<UserModel>>(
      stream: appointmentsController.appointmentsStream.stream,
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
          return _noAppointmentsComponent();
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
                  return _appointmentComponent();
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _noAppointmentsComponent() {
    return SizedBox.shrink();
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
