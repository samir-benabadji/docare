import 'package:docare/presentation/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/assets.gen.dart';
import 'onboarding_controller.dart';
import 'onboarding_name_page.dart';

class OnboardingUserPreviewImagePage extends StatefulWidget {
  const OnboardingUserPreviewImagePage({Key? key}) : super(key: key);

  @override
  State<OnboardingUserPreviewImagePage> createState() => _OnboardingUserPreviewImagePageState();
}

class _OnboardingUserPreviewImagePageState extends State<OnboardingUserPreviewImagePage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      initState: (state) {},
      builder: (onboardingController) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _topBarComponent(),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _titleComponent(),
                        SizedBox(height: 16),
                        _userImagePreviewComponent(onboardingController),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                _saveButtonComponent(onboardingController),
                SizedBox(height: 32)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _userImagePreviewComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          _pickImageMenuPopUp(onboardingController),
        );

        onboardingController.update();
      },
      child: Container(
        alignment: Alignment.center,
        width: 307,
        height: 307,
        decoration: ShapeDecoration(
          color: Color(0xFFF0F1F3),
          shape: OvalBorder(),
          shadows: onboardingController.userImageFile == null
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: Offset(6, 1),
                    spreadRadius: 0,
                  )
                ],
        ),
        child: onboardingController.userImageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.getAPhotoForYourProfile,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Color(0xFF5D6679),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipOval(
                    child: Image.file(
                      onboardingController.userImageFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        Get.dialog(
                          _pickImageMenuPopUp(onboardingController),
                        );

                        onboardingController.update();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: EdgeInsets.all(8),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                        ),
                        child: Image.asset(
                          Assets.icons.camera.path,
                          fit: BoxFit.cover,
                          height: 35,
                          width: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _saveButtonComponent(OnboardingController onboardingController) {
    return GestureDetector(
      onTap: () {
        if (onboardingController.userImageFile != null) Get.to(() => OnboardingNamePage());
      },
      child: Container(
        width: Get.width,
        height: 49,
        margin: EdgeInsets.symmetric(horizontal: 56),
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
          AppLocalizations.of(context)!.saveText,
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

  Widget _titleComponent() {
    return Column(
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
                AppLocalizations.of(context)!.previewProfileImage,
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

  Color _continueButtonColor(OnboardingController onboardingController) {
    return onboardingController.selectedPainTypes.isNotEmpty ? Color(0xFF33CE95) : Color(0x6D53C298);
  }

  Widget _pickImageMenuPopUp(OnboardingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Material(
              child: GestureDetector(
                onTap: () async {
                  final result = await PhotoManager.requestPermissionExtend();

                  await controller.getFromGallery();

                  controller.update();
                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.galleryIcon.path,
                        fit: BoxFit.scaleDown,
                        height: 35,
                        width: 35,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.uploadPhoto,
                        style: GoogleFonts.poppins(
                          color: Color(0xFF100C08),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.21,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
            child: Material(
              child: GestureDetector(
                onTap: () async {
                  final cameraStatus = await Permission.camera.status;
                  controller.update();
                  if (cameraStatus.isGranted) {
                    controller.getFromCamera();
                  } else if (cameraStatus.isPermanentlyDenied) {
                    showToast(
                      AppLocalizations.of(context)!.cameraPermissionPermanentlyDenied,
                    );
                  } else {
                    final cameraPermissionStatus = await Permission.camera.request();
                    if (cameraPermissionStatus.isGranted) {
                      controller.getFromCamera();
                    } else {
                      showToast(
                        AppLocalizations.of(context)!.cameraPermissionDeniedPleaseEnableItInYourDeviceSettings,
                      );
                    }
                  }
                  controller.update();
                },
                child: Container(
                  width: double.infinity,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.cameraIcon.path,
                        fit: BoxFit.scaleDown,
                        height: 35,
                        width: 35,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.takePhoto,
                        style: GoogleFonts.poppins(
                          color: Color(0xFF100C08),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.21,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
