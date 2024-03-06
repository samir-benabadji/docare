import '../../business_logic/models/speciality_model.dart';
import '../assets.gen.dart';

class Constants {
  static List<SpecialityType> specialityTypes = [
    SpecialityType('Cardiology', Assets.images.specialities.cardiology.path),
    SpecialityType('Dermatology', Assets.images.specialities.dermatology.path),
    SpecialityType('Pediatrics', Assets.images.specialities.pediatrics.path),
    SpecialityType('Orthopedics', Assets.images.specialities.orthopedics.path),
    SpecialityType('Neurology', Assets.images.specialities.neurology.path),
    SpecialityType('Psychiatry', Assets.images.specialities.psychiatry.path),
    SpecialityType('Obstetrics', Assets.images.specialities.obstetrics.path),
    SpecialityType('Gastroenterology', Assets.images.specialities.gastroenterology.path),
  ];
}
