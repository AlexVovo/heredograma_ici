import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'brand_logo.dart';

class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const BrandedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Size get preferredSize => const Size.fromHeight(82);

  @override
  Widget build(BuildContext context) {
    final effectiveForegroundColor = foregroundColor ?? Colors.white;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 900;
    final isCompact = screenWidth < 600;
    final isVeryCompact = screenWidth < 360;
    final logoSize = isCompact ? 46.0 : 52.0;

    return AppBar(
      toolbarHeight: 82,
      backgroundColor: Colors.transparent,
      foregroundColor: effectiveForegroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: elevation ?? 3,
      shadowColor: AppTheme.secondary.withValues(alpha: 0.22),
      scrolledUnderElevation: 5,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: backgroundColor == null
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0B2F55),
                    Color(0xFF145D72),
                    Color(0xFF159681),
                  ],
                  stops: [0, 0.56, 1],
                )
              : null,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0),
                  Colors.white.withValues(alpha: 0.38),
                  Colors.white.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ),
      titleSpacing: isDesktop ? 24 : (isCompact ? 0 : 8),
      title: Row(
        children: [
          if (!isDesktop) ...[
            Container(
              width: logoSize,
              height: logoSize,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const BrandLogo.compact(),
              ),
            ),
            SizedBox(width: isCompact ? 8 : 12),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: effectiveForegroundColor,
                    fontSize: isCompact ? 19 : 21,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.25,
                  ),
                ),
                if (!isDesktop && !isVeryCompact) ...[
                  const SizedBox(height: 3),
                  Text(
                    title == 'HeredoOnco'
                        ? isCompact
                            ? 'GENÉTICA  •  PREVENÇÃO'
                            : 'GENÉTICA  •  CUIDADO  •  PREVENÇÃO'
                        : 'HEREDOONCO',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: effectiveForegroundColor.withValues(alpha: 0.72),
                      fontSize: isCompact ? 10.5 : 11.5,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: isCompact ? 0.55 : 0.8,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      actions: actions
          ?.map(
            (action) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconTheme(
                data: IconThemeData(color: effectiveForegroundColor, size: 22),
                child: action,
              ),
            ),
          )
          .toList(),
    );
  }
}
