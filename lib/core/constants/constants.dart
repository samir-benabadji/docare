import 'package:get/get.dart';

import '../../business_logic/models/pain_model.dart';
import '../../business_logic/models/speciality_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../assets.gen.dart';

class Constants {
  static List<SpecialityType> specialityTypes = Get.context != null
      ? [
          SpecialityType(
            "1",
            AppLocalizations.of(Get.context!)!.psychologist,
            Assets.images.specialities.psychologist.path,
          ),
          SpecialityType(
            "2",
            AppLocalizations.of(Get.context!)!.cardiology,
            Assets.images.specialities.cardiology.path,
          ),
          SpecialityType(
            "3",
            AppLocalizations.of(Get.context!)!.opthalmologist,
            Assets.images.specialities.opthalmologist.path,
          ),
          SpecialityType(
            "4",
            AppLocalizations.of(Get.context!)!.nerphrology,
            Assets.images.specialities.nerphrology.path,
          ),
          SpecialityType(
            "5",
            AppLocalizations.of(Get.context!)!.pulmonologist,
            Assets.images.specialities.pulmonologist.path,
          ),
          SpecialityType(
            "6",
            AppLocalizations.of(Get.context!)!.hematologist,
            Assets.images.specialities.hematologist.path,
          ),
          SpecialityType(
            "7",
            AppLocalizations.of(Get.context!)!.dermatology,
            Assets.images.specialities.dermatology.path,
          ),
          SpecialityType(
            "8",
            AppLocalizations.of(Get.context!)!.pediatrics,
            Assets.images.specialities.pediatrics.path,
          ),
          SpecialityType(
            "9",
            AppLocalizations.of(Get.context!)!.orthopedics,
            Assets.images.specialities.orthopedics.path,
          ),
          SpecialityType("10", AppLocalizations.of(Get.context!)!.neurology, Assets.images.specialities.neurology.path),
          SpecialityType(
            "11",
            AppLocalizations.of(Get.context!)!.psychiatry,
            Assets.images.specialities.psychiatry.path,
          ),
          SpecialityType(
            "12",
            AppLocalizations.of(Get.context!)!.obstetrics,
            Assets.images.specialities.obstetrics.path,
          ),
          SpecialityType(
            "13",
            AppLocalizations.of(Get.context!)!.gastroenterology,
            Assets.images.specialities.gastroenterology.path,
          ),
          SpecialityType("14", AppLocalizations.of(Get.context!)!.dentists, Assets.images.specialities.dentists.path),
          SpecialityType(
            "15",
            AppLocalizations.of(Get.context!)!.noseSpecialist,
            Assets.images.specialities.noseSpecialist.path,
          ),
          SpecialityType(
            "16",
            AppLocalizations.of(Get.context!)!.heartSpecialist,
            Assets.images.specialities.heartSpecialist.path,
          ),
          SpecialityType(
            "17",
            AppLocalizations.of(Get.context!)!.cardiologist,
            Assets.images.specialities.cardiologist.path,
          ),
          SpecialityType(
            "18",
            AppLocalizations.of(Get.context!)!.hepatologist,
            Assets.images.specialities.hepatologist.path,
          ),
          SpecialityType(
            "19",
            AppLocalizations.of(Get.context!)!.pancreatigist,
            Assets.images.specialities.pancreatigist.path,
          ),
        ]
      : [];

  static List<PainType> painTypes = Get.context != null
      ? [
          PainType("1", AppLocalizations.of(Get.context!)!.shoulderPain, Assets.images.symptoms.shoulderPain.path),
          PainType("2", AppLocalizations.of(Get.context!)!.kneePain, Assets.images.symptoms.kneePain.path),
          PainType("3", AppLocalizations.of(Get.context!)!.headache, Assets.images.symptoms.headache.path),
          PainType("4", AppLocalizations.of(Get.context!)!.backPain, Assets.images.symptoms.backPain.path),
          PainType("5", AppLocalizations.of(Get.context!)!.fingerFracture, Assets.images.symptoms.fingerFracture.path),
          PainType("6", AppLocalizations.of(Get.context!)!.hipInjury, Assets.images.symptoms.hipInjury.path),
          PainType("7", AppLocalizations.of(Get.context!)!.footPain, Assets.images.symptoms.footPain.path),
          PainType("8", AppLocalizations.of(Get.context!)!.elbowPain, Assets.images.symptoms.elbowPain.path),
        ]
      : [];
}
