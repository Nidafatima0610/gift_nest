import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Reusable generic card widget for Gift Nest.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool showShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.md),
    this.onTap,
    this.backgroundColor = AppColors.surface,
    this.borderColor,
    this.borderRadius = AppDimensions.radiusMd,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: 1,
        ),
        boxShadow: showShadow
            ? const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
