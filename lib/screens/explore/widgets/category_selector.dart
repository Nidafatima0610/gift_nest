import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../data/explore_demo_data.dart';

/// Horizontally scrollable category pills for Explore screen.
class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
        itemCount: ExploreCategories.list.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.sm),
        itemBuilder: (context, index) {
          final category = ExploreCategories.list[index];
          final isSelected = category.toLowerCase() == selectedCategory.toLowerCase();

          return InkWell(
            key: Key('category_chip_${category.toLowerCase().replaceAll(' ', '_')}'),
            borderRadius: BorderRadius.circular(20),
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.warmCream : AppColors.text,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
