import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Style option metadata for packaging selector.
class PackagingStyleOption {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const PackagingStyleOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}

/// Allows user to select their desired packaging theme/style for the gift box.
class PackagingStyleSelector extends StatelessWidget {
  final String selectedStyle;
  final ValueChanged<String> onStyleSelected;

  const PackagingStyleSelector({
    super.key,
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  static const List<PackagingStyleOption> options = [
    PackagingStyleOption(
      title: 'Classic',
      description: 'Traditional warm kraft box with satin burgundy ribbon',
      icon: Icons.inventory_2_rounded,
      accentColor: AppColors.primary,
    ),
    PackagingStyleOption(
      title: 'Soft & Romantic',
      description: 'Pastel blush keepsake box with delicate silk bow',
      icon: Icons.favorite_rounded,
      accentColor: AppColors.softRose,
    ),
    PackagingStyleOption(
      title: 'Minimal',
      description: 'Clean matte ivory box with natural jute twine',
      icon: Icons.crop_square_rounded,
      accentColor: AppColors.darkPrimary,
    ),
    PackagingStyleOption(
      title: 'Festive',
      description: 'Celebratory gold shimmer with sparkling festive trim',
      icon: Icons.celebration_rounded,
      accentColor: Color(0xFFD48B38),
    ),
    PackagingStyleOption(
      title: 'Cute',
      description: 'Playful pastel accents with delightful polka dots',
      icon: Icons.auto_awesome_rounded,
      accentColor: Color(0xFFE57399),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.softRoseLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            const Expanded(
              child: Text(
                'Choose your style',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Select the look and packaging vibe for your custom box.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        ...options.map((option) {
          final isSelected = selectedStyle == option.title;
          return Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.sm),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.warmCream : AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.06)
                      : AppColors.cardShadow,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: Key('packaging_option_${option.title.replaceAll(' ', '_').toLowerCase()}'),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                onTap: () => onStyleSelected(option.title),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: option.accentColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          option.icon,
                          color: option.accentColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.mainText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              option.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: 2,
                          ),
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
