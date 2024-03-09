import '../../business_logic/models/pain_model.dart';
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

  static List<PainType> painTypes = [
    PainType('Shoulder Pain', Assets.images.symptoms.shoulderPain.path),
    PainType('Knee Pain', Assets.images.symptoms.kneePain.path),
    PainType('Headache', Assets.images.symptoms.headache.path),
    PainType('Back Pain', Assets.images.symptoms.backPain.path),
    PainType('Finger Fracture', Assets.images.symptoms.fingerFracture.path),
    PainType('Hip Injury', Assets.images.symptoms.hipInjury.path),
    PainType('Foot Pain', Assets.images.symptoms.footPain.path),
    PainType('Elbow Pain', Assets.images.symptoms.elbowPain.path),
  ];
}
