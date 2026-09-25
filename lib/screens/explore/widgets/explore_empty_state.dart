import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Friendly boutique empty state for Explore screen when no products match filters or search.
class ExploreEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onReset;
  final String resetLabel;

  const ExploreEmptyState({
    super.key,
    this.title = 'Nothing found',
    this.message = 'Try another search or explore a different category.',
    this.onReset,
    this.resetLabel = 'Reset Filters',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.softRoseLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 32,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.darkPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                color: AppColors.secondaryText,
                height: 1.4,
              ),
            ),
            if (onReset != null) ...[
              const SizedBox(height: AppDimensions.md),
              OutlinedButton.icon(
                key: const Key('explore_empty_state_reset_button'),
                onPressed: onReset,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(
                  resetLabel,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
