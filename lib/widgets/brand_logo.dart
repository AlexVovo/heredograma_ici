import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  static const String fullAsset = 'assets/images/heredoonco_logo.png';
  static const String iconAsset = 'assets/images/heredoonco_icon.png';

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
    if (compact) {
      return SizedBox(
        width: width,
        height: height,
        child: ClipRect(
          child: Transform.scale(
            scale: 1.42,
            child: Image.asset(
              iconAsset,
              fit: fit,
              filterQuality: FilterQuality.high,
              semanticLabel: 'Símbolo HeredoOnco',
            ),
          ),
        ),
      );
    }

    final effectiveWidth = width ?? 280;
    final effectiveHeight = height ??
        effectiveWidth *
            (effectiveWidth < 240
                ? .92
                : effectiveWidth < 360
                    ? .74
                    : .62);
    final nameSize = effectiveWidth * .105 < 22 ? 22.0 : effectiveWidth * .105;
    final taglineSize =
        effectiveWidth * .028 < 9.5 ? 9.5 : effectiveWidth * .028;

    return Semantics(
      label: 'HeredoOnco — Mapeie histórias. Entenda gerações. Promova saúde.',
      image: true,
      child: SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: effectiveHeight * (effectiveWidth < 240 ? .45 : .54),
              height: effectiveHeight * (effectiveWidth < 240 ? .45 : .54),
              child: const BrandLogo.compact(),
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: nameSize,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
                children: const [
                  TextSpan(
                    text: 'Heredo',
                    style: TextStyle(color: Color(0xFF0B3B68)),
                  ),
                  TextSpan(
                    text: 'Onco',
                    style: TextStyle(color: Color(0xFF119B83)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            Container(
              width: effectiveWidth * .58,
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B3B68), Color(0xFF17A88E)],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              effectiveWidth < 240
                  ? 'MAPEIE HISTÓRIAS\nPROMOVA SAÚDE'
                  : 'MAPEIE HISTÓRIAS  •  ENTENDA GERAÇÕES\nPROMOVA SAÚDE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF24405F),
                fontSize: taglineSize,
                height: 1.45,
                fontWeight: FontWeight.w700,
                letterSpacing: effectiveWidth >= 320 ? 1.25 : .65,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
