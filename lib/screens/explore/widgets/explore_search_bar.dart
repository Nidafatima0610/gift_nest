import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Functional search bar for the Explore screen.
class ExploreSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const ExploreSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        key: const Key('explore_search_text_field'),
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.text,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search gifts, products or creators',
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.secondaryText,
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  key: const Key('explore_search_clear_button'),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.secondaryText,
                    size: 18,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
