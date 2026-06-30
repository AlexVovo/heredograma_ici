import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  static const String fullAsset = 'assets/images/heredoconco_logo.png';
  static const String iconAsset = 'assets/images/heredoconco_icon.png';

  final double? width;
  final double? height;
  final bool compact;
  final BoxFit fit;

  const BrandLogo({
    super.key,
    this.width,
    this.height,
    this.compact = false,
    this.fit = BoxFit.contain,
  });

  const BrandLogo.compact({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  }) : compact = true;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      compact ? iconAsset : fullAsset,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
      semanticLabel: 'Logo HeredoConco',
    );
  }
}
