import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// A reusable boutique card container with subtle shadow and border.
class GiftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const GiftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.md),
    this.onTap,
    this.backgroundColor = AppColors.surface,
    this.borderColor,
    this.borderRadius = AppDimensions.radiusMd,
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
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
