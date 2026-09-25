import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../data/explore_demo_data.dart';

/// Bottom sheet for selecting Explore sorting criteria.
class SortBottomSheet extends StatelessWidget {
  final ExploreSortOption selectedSort;
  final ValueChanged<ExploreSortOption> onSelectSort;

  const SortBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSelectSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.sm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_vert_rounded, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Sort Gifts By',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.secondaryText),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.border),

            // Options List
            ...ExploreSortOption.values.map((option) {
              final isSelected = option == selectedSort;
              final sanitizedKey =
                  'sort_option_${option.name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';

              return InkWell(
                key: Key(sanitizedKey),
                onTap: () {
                  onSelectSort(option);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Text(
                        option.label,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.primary : AppColors.text,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: AppColors.primary,
                        )
                      else
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border, width: 1.5),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: AppDimensions.md),
          ],
        ),
      ),
    );
  }
}
