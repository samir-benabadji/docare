import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../core/assets.gen.dart';
import '../location/location_map_page.dart';
import 'onboarding_controller.dart';
import 'onboarding_user_picture_page.dart';

class OnboardingManualLocationPage extends StatefulWidget {
  const OnboardingManualLocationPage({Key? key}) : super(key: key);

  @override
  _OnboardingManualLocationPageState createState() => _OnboardingManualLocationPageState();
}

class _OnboardingManualLocationPageState extends State<OnboardingManualLocationPage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      initState: (state) {},
      builder: (onboardingController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _topBarComponent(),
                SizedBox(height: 8),
                _titleComponent(),
                SizedBox(height: 25),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 33),
                    child: Column(
                      children: [
                        _locationTextFieldComponent(onboardingController),
                        SizedBox(height: 15),
                        _currentLocationButtonComponent(),
                        SizedBox(height: 15),
                        _chooseOnMapButtonComponent(context),
                      ],
                    ),
                  ),
                ),
                _continueButtonComponent(onboardingController),
                SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _continueButtonComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () {
        if (onboardingController.locationTextEditingController.text.isNotEmpty)
          Get.to(() => OnboardingUserPicturePage());
      },
      child: Container(
        width: Get.width,
        height: 49,
        margin: EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: _continueButtonColor(onboardingController),
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
          'Continue',
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontSize: 18.55,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.35,
          ),
        ),
      ),
    );
  }

  Color _continueButtonColor(OnboardingController onboardingController) {
    return onboardingController.locationTextEditingController.text.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }

  Widget _currentLocationButtonComponent() {
    return GestureDetector(
      onTap: () async {
        try {
          final onboardingController = Get.find<OnboardingController>();
          final currentPosition = await onboardingController.getCurrentLocation();
          onboardingController.locationTextEditingController.text = currentPosition;
          print(currentPosition); // Just for confirmation
        } catch (e) {
          Get.snackbar(
            'Location Error',
            'Failed to get current location: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.icons.geoPinpoint.path,
          ),
          SizedBox(width: 5),
          Text(
            'Use my current location',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Color(0xFF090F47),
              fontSize: 16.23,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chooseOnMapButtonComponent(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            final String? pickedLocation = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LocationMapPage()),
            );

            if (pickedLocation != null) {
              print("Picked Location: $pickedLocation");
            }
          },
          child: Text("Choose on the map"),
        ),
      ],
    );
  }

  Widget _locationTextFieldComponent(OnboardingController onboardingController) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: onboardingController.locationTextEditingController,
        decoration: InputDecoration(
          hintText: 'Set your location...',
          contentPadding: EdgeInsets.only(left: 11, right: 7),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 0.30, color: Color(0xFF090F47)),
            borderRadius: BorderRadius.circular(11),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.30, color: Color(0xFF090F47)),
            borderRadius: BorderRadius.circular(11),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.30, color: Color(0xFF090F47)),
            borderRadius: BorderRadius.circular(11),
          ),
          prefixIcon: Icon(Icons.search),
          suffixIcon: onboardingController.locationTextEditingController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    onboardingController.locationTextEditingController.clear();
                    onboardingController.update();
                  },
                )
              : null,
        ),
      ),
      suggestionsCallback: (pattern) async {
        return await onboardingController.fetchSuggestions(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {},
    );
  }

  Widget _titleComponent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
              Expanded(
                child: Text(
                  "What's your location ?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    color: Color(0xFF090F47),
                    fontSize: 18.13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.34,
                  ),
                ),
              ),
              SizedBox(width: 32),
            ],
          ),
        ],
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
