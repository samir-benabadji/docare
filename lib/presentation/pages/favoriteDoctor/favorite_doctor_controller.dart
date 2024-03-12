import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';

class FavoriteDoctorController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = FirebaseFirestoreService();
  final BehaviorSubject<List<UserModel>> favoriteDoctorsStream = BehaviorSubject();

  @override
  void onClose() {
    favoriteDoctorsStream.close();
    super.onClose();
  }

  @override
  void onInit() {
    loadFavoriteDoctors();
    super.onInit();
  }

  void loadFavoriteDoctors() async {
    List<String>? favoriteDoctorIds = Get.find<FirebaseFirestoreService>().userModel?.favoriteDoctors;
    if (favoriteDoctorIds == null || favoriteDoctorIds.isEmpty) {
      if (!favoriteDoctorsStream.isClosed) {
        favoriteDoctorsStream.add([]);
      }
      return;
    }

    try {
      final doctors = await _firebaseFirestoreService.getDoctorsByIds(favoriteDoctorIds);
      if (favoriteDoctorsStream.isClosed == false) {
        favoriteDoctorsStream.add(doctors);
      }
    } catch (e) {
      print('Error loading favorite doctors: $e');
      if (favoriteDoctorsStream.isClosed == false) {
        favoriteDoctorsStream.addError('Failed to load favorite doctors');
      }
    }
  }
}
