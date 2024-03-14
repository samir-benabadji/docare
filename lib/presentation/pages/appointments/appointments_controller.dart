import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../business_logic/models/user_model.dart';

class AppointmentsController extends GetxController {
  final BehaviorSubject<List<UserModel>> appointmentsStream = BehaviorSubject();

  String appointmentCategory = "Upcoming";
  @override
  void onClose() {
    appointmentsStream.close();
    super.onClose();
  }
}
