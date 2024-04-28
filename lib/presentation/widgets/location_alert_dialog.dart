import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationPermissionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Preventing dismissing the dialog with the back button
      child: AlertDialog(
        title: Text(
          Get.context != null ? AppLocalizations.of(Get.context!)!.locationPermissionTitle : 'Location Permission',
        ),
        content: Text(
          Get.context != null
              ? AppLocalizations.of(Get.context!)!.locationPermissionMessage
              : 'This app requires access to your location to find nearby doctors.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // Request location permission
              var status = await Permission.location.request();

              if (status.isGranted) {
                // Permission granted
                Get.back(result: true);
              } else if (status.isPermanentlyDenied) {
                // Permission permanently denied
                Get.snackbar(
                  Get.context != null ? AppLocalizations.of(Get.context!)!.permissionDeniedTitle : 'Permission Denied',
                  Get.context != null
                      ? AppLocalizations.of(Get.context!)!.enableLocationPermissionMessage
                      : 'Please enable location permission in settings',
                  duration: Duration(seconds: 5),
                );
              } else {
                // Permission denied
                Get.snackbar(
                  Get.context != null ? AppLocalizations.of(Get.context!)!.permissionDeniedTitle : 'Permission Denied',
                  Get.context != null
                      ? AppLocalizations.of(Get.context!)!.locationPermissionRequiredMessage
                      : 'Location permission is required to find nearby doctors',
                );
              }
            },
            child: Text(
              Get.context != null ? AppLocalizations.of(Get.context!)!.allow : 'Allow',
            ),
          ),
        ],
      ),
    );
  }
}
