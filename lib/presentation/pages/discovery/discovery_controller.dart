import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../business_logic/models/user_model.dart';
import '../../../business_logic/services/firebase_firestore_service.dart';

class DiscoveryController extends GetxController {
  final FirebaseFirestoreService _firebaseFirestoreService = FirebaseFirestoreService();
  final BehaviorSubject<List<UserModel>> doctorsStream = BehaviorSubject();

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  void loadDoctors() {
    _firebaseFirestoreService.getDoctorsStream().listen(
      (data) {
        doctorsStream.add(data);
      },
      onError: (error) {
        print("Error loading doctors: $error");
        // TODO: Handle possible errors
      },
    );
  }

  @override
  void onClose() {
    doctorsStream.close();
    super.onClose();
  }
}
