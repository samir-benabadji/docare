import 'package:get/get.dart';

import '../../business_logic/models/pain_model.dart';
import '../../business_logic/models/speciality_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../assets.gen.dart';

class Constants {
  static List<SpecialityType> specialityTypes = Get.context != null
      ? [
          SpecialityType(AppLocalizations.of(Get.context!)!.psychologist, Assets.images.specialities.psychologist.path),
          SpecialityType(AppLocalizations.of(Get.context!)!.cardiology, Assets.images.specialities.cardiology.path),
          SpecialityType(
            AppLocalizations.of(Get.context!)!.opthalmologist,
            Assets.images.specialities.opthalmologist.path,
          ),
          SpecialityType(AppLocalizations.of(Get.context!)!.nerphrology, Assets.images.specialities.nerphrology.path),
          SpecialityType(
            AppLocalizations.of(Get.context!)!.pulmonologist,
            Assets.images.specialities.pulmonologist.path,
          ),
          SpecialityType(AppLocalizations.of(Get.context!)!.hematologist, Assets.images.specialities.hematologist.path),
          SpecialityType(AppLocalizations.of(Get.context!)!.dermatology, Assets.images.specialities.dermatology.path),
          SpecialityType(AppLocalizations.of(Get.context!)!.pediatrics, Assets.images.specialities.pediatrics.path),
          SpecialityType(AppLocalizations.of(Get.context!)!.orthopedics, Assets.images.specialities.orthopedics.path),
          SpecialityType(AppLocalizations.of(Get.context!)!.neurology, Assets.images.specialities.neurology.path),
          SpecialityType(AppLocalizations.of(Get.context!)!.psychiatry, Assets.images.specialities.psychiatry.path),
          SpecialityType(AppLocalizations.of(Get.context!)!.obstetrics, Assets.images.specialities.obstetrics.path),
          SpecialityType(
            AppLocalizations.of(Get.context!)!.gastroenterology,
            Assets.images.specialities.gastroenterology.path,
          ),
          SpecialityType(AppLocalizations.of(Get.context!)!.dentists, Assets.images.specialities.dentists.path),
          SpecialityType(
            AppLocalizations.of(Get.context!)!.noseSpecialist,
            Assets.images.specialities.noseSpecialist.path,
          ),
          SpecialityType(
            AppLocalizations.of(Get.context!)!.heartSpecialist,
            Assets.images.specialities.heartSpecialist.path,
          ),
          SpecialityType(AppLocalizations.of(Get.context!)!.cardiologist, Assets.images.specialities.cardiologist.path),
          SpecialityType(AppLocalizations.of(Get.context!)!.hepatologist, Assets.images.specialities.hepatologist.path),
          SpecialityType(
            AppLocalizations.of(Get.context!)!.pancreatigist,
            Assets.images.specialities.pancreatigist.path,
          ),
        ]
      : [];

  static List<PainType> painTypes = Get.context != null
      ? [
          PainType(AppLocalizations.of(Get.context!)!.shoulderPain, Assets.images.symptoms.shoulderPain.path),
          PainType(AppLocalizations.of(Get.context!)!.kneePain, Assets.images.symptoms.kneePain.path),
          PainType(AppLocalizations.of(Get.context!)!.headache, Assets.images.symptoms.headache.path),
          PainType(AppLocalizations.of(Get.context!)!.backPain, Assets.images.symptoms.backPain.path),
          PainType(AppLocalizations.of(Get.context!)!.fingerFracture, Assets.images.symptoms.fingerFracture.path),
          PainType(AppLocalizations.of(Get.context!)!.hipInjury, Assets.images.symptoms.hipInjury.path),
          PainType(AppLocalizations.of(Get.context!)!.footPain, Assets.images.symptoms.footPain.path),
          PainType(AppLocalizations.of(Get.context!)!.elbowPain, Assets.images.symptoms.elbowPain.path),
        ]
      : [];
}
