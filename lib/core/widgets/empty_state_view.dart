import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'custom_button.dart';

/// An elegant empty/placeholder state view with title, description, and optional action.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.softRoseLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 38,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppDimensions.lg),
              CustomButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                width: 180,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
