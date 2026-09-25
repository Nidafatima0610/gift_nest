import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

enum AppButtonVariant { primary, secondary, outline, text }

/// Reusable generic button for Gift Nest.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = AppDimensions.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = Colors.white;
        borderSide = null;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = AppColors.softRoseLight;
        foregroundColor = AppColors.darkPrimary;
        borderSide = null;
        break;
      case AppButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.border, width: 1.5);
        break;
      case AppButtonVariant.text:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        borderSide = null;
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: isEnabled ? backgroundColor : AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          side: borderSide ?? BorderSide.none,
        ),
        child: InkWell(
          borderRadius: AppDimensions.borderRadiusMd,
          onTap: isEnabled ? onPressed : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
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
                        Flexible(
                          child: Text(
                            text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isEnabled ? foregroundColor : AppColors.secondaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
