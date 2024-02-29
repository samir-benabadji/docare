/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/DOCARE_logo.svg
  SvgGenImage get dOCARELogo => const SvgGenImage('assets/icons/DOCARE_logo.svg');

  /// File path: assets/icons/DOCARE_logo_text.svg
  SvgGenImage get dOCARELogoText => const SvgGenImage('assets/icons/DOCARE_logo_text.svg');

  /// File path: assets/icons/DOCARE_text.svg
  SvgGenImage get dOCAREText => const SvgGenImage('assets/icons/DOCARE_text.svg');

  $AssetsIconsAuthGen get auth => const $AssetsIconsAuthGen();

  /// File path: assets/icons/check_green.png
  AssetGenImage get checkGreen => const AssetGenImage('assets/icons/check_green.png');

  /// File path: assets/icons/new_user.svg
  SvgGenImage get newUser => const SvgGenImage('assets/icons/new_user.svg');

  /// List of all assets
  List<dynamic> get values => [dOCARELogo, dOCARELogoText, dOCAREText, checkGreen, newUser];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Creative_panel_planner.png
  AssetGenImage get creativePanelPlanner => const AssetGenImage('assets/images/Creative_panel_planner.png');

  /// File path: assets/images/docareButtonLayout.svg
  SvgGenImage get docareButtonLayout => const SvgGenImage('assets/images/docareButtonLayout.svg');

  $AssetsImagesSpecialitiesGen get specialities => const $AssetsImagesSpecialitiesGen();
  $AssetsImagesSymptomsGen get symptoms => const $AssetsImagesSymptomsGen();

  /// List of all assets
  List<dynamic> get values => [creativePanelPlanner, docareButtonLayout];
}

class $AssetsIconsAuthGen {
  const $AssetsIconsAuthGen();

  /// File path: assets/icons/auth/address.svg
  SvgGenImage get address => const SvgGenImage('assets/icons/auth/address.svg');

  /// File path: assets/icons/auth/lock-check.svg
  SvgGenImage get lockCheck => const SvgGenImage('assets/icons/auth/lock-check.svg');

  /// File path: assets/icons/auth/lock.svg
  SvgGenImage get lock => const SvgGenImage('assets/icons/auth/lock.svg');

  /// List of all assets
  List<SvgGenImage> get values => [address, lockCheck, lock];
}

class $AssetsImagesSpecialitiesGen {
  const $AssetsImagesSpecialitiesGen();

  /// File path: assets/images/specialities/Cardiology.png
  AssetGenImage get cardiology => const AssetGenImage('assets/images/specialities/Cardiology.png');

  /// File path: assets/images/specialities/Dermatology.png
  AssetGenImage get dermatology => const AssetGenImage('assets/images/specialities/Dermatology.png');

  /// File path: assets/images/specialities/Gastroenterology.png
  AssetGenImage get gastroenterology => const AssetGenImage('assets/images/specialities/Gastroenterology.png');

  /// File path: assets/images/specialities/Neurology.png
  AssetGenImage get neurology => const AssetGenImage('assets/images/specialities/Neurology.png');

  /// File path: assets/images/specialities/Obstetrics.png
  AssetGenImage get obstetrics => const AssetGenImage('assets/images/specialities/Obstetrics.png');

  /// File path: assets/images/specialities/Orthopedics.png
  AssetGenImage get orthopedics => const AssetGenImage('assets/images/specialities/Orthopedics.png');

  /// File path: assets/images/specialities/Pediatrics.png
  AssetGenImage get pediatrics => const AssetGenImage('assets/images/specialities/Pediatrics.png');

  /// File path: assets/images/specialities/Psychiatry.png
  AssetGenImage get psychiatry => const AssetGenImage('assets/images/specialities/Psychiatry.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [cardiology, dermatology, gastroenterology, neurology, obstetrics, orthopedics, pediatrics, psychiatry];
}

class $AssetsImagesSymptomsGen {
  const $AssetsImagesSymptomsGen();

  /// File path: assets/images/symptoms/back_pain.png
  AssetGenImage get backPain => const AssetGenImage('assets/images/symptoms/back_pain.png');

  /// File path: assets/images/symptoms/elbow_pain.png
  AssetGenImage get elbowPain => const AssetGenImage('assets/images/symptoms/elbow_pain.png');

  /// File path: assets/images/symptoms/finger_fracture.png
  AssetGenImage get fingerFracture => const AssetGenImage('assets/images/symptoms/finger_fracture.png');

  /// File path: assets/images/symptoms/foot_pain.png
  AssetGenImage get footPain => const AssetGenImage('assets/images/symptoms/foot_pain.png');

  /// File path: assets/images/symptoms/headache.png
  AssetGenImage get headache => const AssetGenImage('assets/images/symptoms/headache.png');

  /// File path: assets/images/symptoms/hip_injury.png
  AssetGenImage get hipInjury => const AssetGenImage('assets/images/symptoms/hip_injury.png');

  /// File path: assets/images/symptoms/knee_pain.png
  AssetGenImage get kneePain => const AssetGenImage('assets/images/symptoms/knee_pain.png');

  /// File path: assets/images/symptoms/shoulder_pain.png
  AssetGenImage get shoulderPain => const AssetGenImage('assets/images/symptoms/shoulder_pain.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [backPain, elbowPain, fingerFracture, footPain, headache, hipInjury, kneePain, shoulderPain];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
