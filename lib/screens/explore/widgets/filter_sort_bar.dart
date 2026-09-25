import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../data/explore_demo_data.dart';

/// Filter & Sort bar row displayed beneath the category selector.
class FilterSortBar extends StatelessWidget {
  final int activeFilterCount;
  final ExploreSortOption selectedSort;
  final int totalProductCount;
  final VoidCallback onOpenFilter;
  final VoidCallback onOpenSort;

  const FilterSortBar({
    super.key,
    required this.activeFilterCount,
    required this.selectedSort,
    required this.totalProductCount,
    required this.onOpenFilter,
    required this.onOpenSort,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      child: Row(
        children: [
          // Total items count indicator
          Flexible(
            child: Text(
              '$totalProductCount gifts',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ),
          ),

          const SizedBox(width: AppDimensions.sm),

          // Filter Button with Badge
          InkWell(
            key: const Key('explore_filter_button'),
            borderRadius: BorderRadius.circular(10),
            onTap: onOpenFilter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: activeFilterCount > 0
                    ? AppColors.primaryLight
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: activeFilterCount > 0
                      ? AppColors.primary
                      : AppColors.border,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 15,
                    color: activeFilterCount > 0
                        ? AppColors.primary
                        : AppColors.darkPrimary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: activeFilterCount > 0
                          ? AppColors.primary
                          : AppColors.darkPrimary,
                    ),
                  ),
                  if (activeFilterCount > 0) ...[
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$activeFilterCount',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warmCream,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(width: AppDimensions.xs),

          // Sort Button
          InkWell(
            key: const Key('explore_sort_button'),
            borderRadius: BorderRadius.circular(10),
            onTap: onOpenSort,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.swap_vert_rounded,
                    size: 15,
                    color: AppColors.darkPrimary,
                  ),
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 82),
                    child: Text(
                      selectedSort.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
