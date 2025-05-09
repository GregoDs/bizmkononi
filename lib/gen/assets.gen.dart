/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/BIZ_MKONONI.png
  AssetGenImage get bizMkononi =>
      const AssetGenImage('assets/images/BIZ_MKONONI.png');

  /// File path: assets/images/aipowered.png
  AssetGenImage get aipowered =>
      const AssetGenImage('assets/images/aipowered.png');

  /// File path: assets/images/analytics.png
  AssetGenImage get analytics =>
      const AssetGenImage('assets/images/analytics.png');

  /// File path: assets/images/bi-analytics.png
  AssetGenImage get biAnalytics =>
      const AssetGenImage('assets/images/bi-analytics.png');

  /// File path: assets/images/business.png
  AssetGenImage get business =>
      const AssetGenImage('assets/images/business.png');

  /// File path: assets/images/drawer.png
  AssetGenImage get drawer => const AssetGenImage('assets/images/drawer.png');

  /// File path: assets/images/emptyData.png
  AssetGenImage get emptyData =>
      const AssetGenImage('assets/images/emptyData.png');

  /// File path: assets/images/facebook.png
  AssetGenImage get facebook =>
      const AssetGenImage('assets/images/facebook.png');

  /// File path: assets/images/insta.png
  AssetGenImage get insta => const AssetGenImage('assets/images/insta.png');

  /// File path: assets/images/linkedin.png
  AssetGenImage get linkedin =>
      const AssetGenImage('assets/images/linkedin.png');

  /// File path: assets/images/logotext.png
  AssetGenImage get logotext =>
      const AssetGenImage('assets/images/logotext.png');

  /// File path: assets/images/revenuecharts.png
  AssetGenImage get revenuecharts =>
      const AssetGenImage('assets/images/revenuecharts.png');

  /// File path: assets/images/risk-analysis.png
  AssetGenImage get riskAnalysis =>
      const AssetGenImage('assets/images/risk-analysis.png');

  /// File path: assets/images/twitter.png
  AssetGenImage get twitter => const AssetGenImage('assets/images/twitter.png');

  /// File path: assets/images/view.png
  AssetGenImage get view => const AssetGenImage('assets/images/view.png');

  /// File path: assets/images/whatsapp.png
  AssetGenImage get whatsapp =>
      const AssetGenImage('assets/images/whatsapp.png');

  /// File path: assets/images/youtube.png
  AssetGenImage get youtube => const AssetGenImage('assets/images/youtube.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        bizMkononi,
        aipowered,
        analytics,
        biAnalytics,
        business,
        drawer,
        emptyData,
        facebook,
        insta,
        linkedin,
        logotext,
        revenuecharts,
        riskAnalysis,
        twitter,
        view,
        whatsapp,
        youtube
      ];
}

class Assets {
  Assets._();

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
