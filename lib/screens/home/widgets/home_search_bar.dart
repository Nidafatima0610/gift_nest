import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';

/// Prominent rounded boutique search bar for Home screen.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.xs,
      ),
      child: GestureDetector(
        key: const Key('home_search_bar'),
        onTap: () => Navigator.pushNamed(context, AppRoutes.explore),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: AppDimensions.sm),
              const Expanded(
                child: Text(
                  'Search gifts, creators or occasions',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.warmCream,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.darkPrimary,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
