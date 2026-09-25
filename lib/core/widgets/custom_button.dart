import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

enum CustomButtonVariant { primary, secondary, outline }

/// A reusable boutique button for Gift Nest with loading and variant support.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final CustomButtonVariant variant;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = CustomButtonVariant.primary,
    this.icon,
    this.width,
    this.height = AppDimensions.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? double.infinity;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (variant) {
      case CustomButtonVariant.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = Colors.white;
        borderSide = null;
        break;
      case CustomButtonVariant.secondary:
        backgroundColor = AppColors.softRoseLight;
        foregroundColor = AppColors.darkPrimary;
        borderSide = null;
        break;
      case CustomButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.border, width: 1.5);
        break;
    }

    final isInteractive = onPressed != null && !isLoading;

    return SizedBox(
      width: effectiveWidth,
      height: height,
      child: Material(
        color: isInteractive ? backgroundColor : AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          side: borderSide ?? BorderSide.none,
        ),
        child: InkWell(
          borderRadius: AppDimensions.borderRadiusMd,
          onTap: isInteractive ? onPressed : null,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: AppDimensions.iconSm, color: foregroundColor),
                        const SizedBox(width: AppDimensions.sm),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: isInteractive ? foregroundColor : AppColors.secondaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
