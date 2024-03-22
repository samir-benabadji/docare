import 'dart:io';

import 'package:docare/business_logic/models/session_model.dart';
import 'package:docare/business_logic/models/speciality_model.dart';
import 'package:docare/core/constants/theme.dart';
import 'package:docare/presentation/pages/auth/auth_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../../../business_logic/models/pain_model.dart';
import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_auth_service.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';
import '../../../business_logic/services/firebase_storage_service.dart';

class OnboardingController extends GetxController {
  UserModel? userModel;
  OnboardingController({this.userModel});

  RxList<PainType> selectedPainTypes = <PainType>[].obs;
  Rx<SpecialityType> selectedSpecialityType = SpecialityType("", "").obs;
  // options
  RxList<SelectedOption> selectedOptions = <SelectedOption>[].obs;
  List<String> options = [
    "IRM (Imagerie par Résonance Magnétique)",
    "Scanner (Tomodensitométrie)",
    "Radiographie (X-ray machine)",
    "Échographe (Échographie médicale)",
    "Colposcope (Colposcopie)",
    "Stéthoscope",
    "Otoscope et Ophtalmoscope",
    "Électrocardiographe (ECG)",
    "Appareil de mesure de la pression artérielle",
    "Analyseur sanguin"
  ];

  // Work Schedule
  int currentSelectedTimeStamp = 0;
  Map<String, List<Map<String, dynamic>>>? workingHours;
  List<SessionModel> allSessions = [];

  // location access
  TextEditingController locationTextEditingController = TextEditingController();
  DateTime _lastApiRequestTime = DateTime.now().subtract(Duration(seconds: 1));
  Map<String, List<String>> _cache = {};

  // user's image
  File? userImageFile;

  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isSavedSuccessfully = false;

  @override
  void onInit() {
    if (userModel == null) getUserDataModel();
    super.onInit();
  }

  String getSelectedOptionsAsString() {
    return selectedOptions.map((option) => option.name).join(', ');
  }

  getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      final _cropFile = await cropImage((File(pickedFile.path)));
      if (_cropFile != null) {
        userImageFile = _cropFile;
        update();
      }
    }
    Get.back();
    update();
  }

  getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      final _cropFile = await cropImage(File(pickedFile.path));
      if (_cropFile != null) {
        userImageFile = _cropFile;
        update();
      }
    }
    update();
  }

  Future<File?> cropImage(File? file) async {
    if (file == null) return null;
    final _cf = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 5),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 70,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        activeControlsWidgetColor: Colors.blue,
        // initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(title: 'Crop Image'),
    );

    return _cf;
  }

  Future<List<String>> fetchSuggestions(String input) async {
    if (input.isEmpty) return [];

    // Checking cache first
    if (_cache.containsKey(input)) {
      return _cache[input]!;
    }

    // Ensuring at least 1 second has passed since the last API request
    final currentTime = DateTime.now();
    if (currentTime.difference(_lastApiRequestTime).inSeconds < 1) {
      // Waiting if less than a second has passed
      await Future.delayed(Duration(seconds: 1));
    }

    // Updating last API request time
    _lastApiRequestTime = DateTime.now();

    final url = Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=$input');
    final response = await http.get(url, headers: {'User-Agent': 'YourApp/1.0'});

    if (response.statusCode == 200) {
      final List<dynamic> result = json.decode(response.body);
      final suggestions = result.map((data) => data['display_name'] as String).toList();

      // Caching the results
      _cache[input] = suggestions;

      return suggestions;
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Checking if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // When permissions are granted, we get the current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      // Constructing an address string from the first placemark.

      Placemark place = placemarks.first;
      String address = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      return address;
    } else {
      throw Exception('No address found.');
    }
  }

  // location access
  Future<void> requestLocationAccess() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Testing if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, we cannot request permission.
      Get.snackbar(
        'Location Service Disabled',
        'Please enable your location services.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time we could try requesting permissions again (this is also where Android's shouldShowRequestPermissionRationale returns true).
        Get.snackbar(
          'Location Permission',
          'Location permissions are denied',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever.
      Get.snackbar(
        'Location Permission',
        'Location permissions are permanently denied, we cannot request permissions.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // When we reach here, permissions are granted and we can continue accessing the device's location.
    Position position = await Geolocator.getCurrentPosition();
    Get.snackbar(
      'Location',
      'Location: ${position.latitude}, ${position.longitude}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void sortOptions() {
    options.sort((a, b) {
      bool aSelected = selectedOptions.any((option) => option.name == a);
      bool bSelected = selectedOptions.any((option) => option.name == b);

      if (aSelected && !bSelected) {
        return -1;
      } else if (!aSelected && bSelected) {
        return 1;
      } else {
        return 0;
      }
    });
    update();
  }

  void getUserDataModel() async {
    final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
    final FirebaseAuthService _firebaseAuthService = Get.find<FirebaseAuthService>();

    if (_firebaseAuthService.user != null)
      userModel = await _firebaseFirestoreService.getUserData(_firebaseAuthService.user!.uid);
    update();
  }

  void togglePainTypeSelection(PainType painType) {
    if (selectedPainTypes.contains(painType)) {
      selectedPainTypes.remove(painType);
    } else {
      selectedPainTypes.add(painType);
    }
    update();
  }

  void setMedicalSpeciality(SpecialityType specialityType) {
    selectedSpecialityType.value = specialityType;
    update();
  }

  Future<bool> updateUserInfo() async {
    try {
      final FirebaseFirestoreService _firebaseFirestoreService = Get.find<FirebaseFirestoreService>();
      final FirebaseStorageService _firebaseStorageService = Get.find<FirebaseStorageService>();

      String? uid = userModel?.uid;
      if (uid == null) return false;

      String profileImageUrl = '';
      if (userImageFile != null) {
        profileImageUrl = await _firebaseStorageService.uploadUserImage(uid, userImageFile!);
      }

      Map<String, dynamic> userUpdatedData = {
        'status': 'COMPLETED',
        'name': nameController.text,
        'profileImageUrl': profileImageUrl,
        'userType': userModel?.userType,
      };

      if (userModel?.userType == 1) {
        userUpdatedData.addAll({
          'symptoms': selectedPainTypes.map((painType) => painType.title).toList(),
          "medicalSpeciality": selectedSpecialityType.value.title,
          "addressLocation": locationTextEditingController.text,
          "phoneNumber": Get.find<AuthController>().currentPhoneNumber.phoneNumber,
          "phoneNumberDialCode": Get.find<AuthController>().currentPhoneNumber.dialCode,
          "options": selectedOptions.map((option) => {'name': option.name, 'price': option.price}).toList(),
          'workingHours': workingHours,
        });
      } else if (userModel?.userType == 2) {
        userUpdatedData.addAll({
          'symptoms': selectedPainTypes.map((painType) => painType.title).toList(),
        });
      }

      await _firebaseFirestoreService.addOrUpdateUser(uid, userUpdatedData, isUpdatingUser: true);
      return true;
    } catch (e) {
      print('Error updating user info in Firestore: $e');
      return false;
    }
  }

  void toggleOptionSelection(String option) {
    bool alreadySelected = selectedOptions.any((element) => element.name == option);

    if (alreadySelected) {
      selectedOptions.removeWhere((element) => element.name == option);
    } else {
      SelectedOption newOption = SelectedOption(option);
      selectedOptions.add(newOption);
    }
    sortOptions();
  }

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }
    return true;
  }

  void onSaveClicked() {
    if (allSessions.isEmpty) {
      Get.snackbar(
        'No Sessions Added',
        'Please add at least one session to save your schedule',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
        backgroundColor: DocareTheme.tomato,
        colorText: Colors.white,
      );
      return;
    }

    // Checking if any session has null startAt or endAt
    bool hasIncompleteSessions = allSessions.any((session) => session.startAt == null || session.endAt == null);

    if (hasIncompleteSessions) {
      Get.snackbar(
        'Incomplete Sessions',
        'Please finish filling the sessions that you added',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
        backgroundColor: DocareTheme.tomato,
        colorText: Colors.white,
      );
      return;
    }

    // Checking for conflicts between session timings
    bool hasConflict = false;
    for (int i = 0; i < allSessions.length; i++) {
      for (int j = i + 1; j < allSessions.length; j++) {
        if (allSessions[i].timestamp == allSessions[j].timestamp) {
          DateTime startDateTimeI = DateTime(1, 1, 1, allSessions[i].startAt!.hour, allSessions[i].startAt!.minute);
          DateTime endDateTimeI = DateTime(1, 1, 1, allSessions[i].endAt!.hour, allSessions[i].endAt!.minute);
          DateTime startDateTimeJ = DateTime(1, 1, 1, allSessions[j].startAt!.hour, allSessions[j].startAt!.minute);
          DateTime endDateTimeJ = DateTime(1, 1, 1, allSessions[j].endAt!.hour, allSessions[j].endAt!.minute);

          if ((startDateTimeI.isBefore(endDateTimeJ) && endDateTimeI.isAfter(startDateTimeJ)) ||
              (startDateTimeJ.isBefore(endDateTimeI) && endDateTimeJ.isAfter(startDateTimeI))) {
            // Conflict
            hasConflict = true;
            break;
          }
        }
      }
      if (hasConflict) {
        break;
      }
    }

    if (hasConflict) {
      Get.snackbar(
        'Time Conflict',
        'Please fix the time conflicts between sessions',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
        backgroundColor: DocareTheme.tomato,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      'Success',
      'All sessions are saved successfully',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 5),
      backgroundColor: DocareTheme.apple,
      colorText: Colors.white,
    );
    workingHours = mapSessionsToWorkingHours(allSessions);
    isSavedSuccessfully = true;
    update();
  }

  Map<String, List<Map<String, dynamic>>> mapSessionsToWorkingHours(List<SessionModel> sessions) {
    Map<String, List<Map<String, dynamic>>> mappedSessions = {};

    for (var session in sessions) {
      final timestamp = session.timestamp.toString();
      final start = formatTimeOfDay(session.startAt!);
      final end = formatTimeOfDay(session.endAt!);

      if (!mappedSessions.containsKey(timestamp)) {
        mappedSessions[timestamp] = [];
      }

      mappedSessions[timestamp]!.add({
        'start at': start,
        'end at': end,
      });
    }

    return mappedSessions;
  }

  void deleteSessionById(String sessionId) {
    allSessions.removeWhere((session) => session.id == sessionId);
    isSavedSuccessfully = false;
    update();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return "$hour:$minute ${time.period.name}";
  }
}

class SelectedOption {
  String name;
  double price;

  SelectedOption(this.name, {this.price = 0});
}
