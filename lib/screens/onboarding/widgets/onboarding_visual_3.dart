import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Boutique illustration for Onboarding Page 3: "Build your perfect gift".
class OnboardingVisual3 extends StatelessWidget {
  const OnboardingVisual3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.warmCream,
        borderRadius: AppDimensions.borderRadiusXl,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft circle
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softRoseLight.withValues(alpha: 0.5),
            ),
          ),

          // Main Open Keepsake Box Container
          Container(
            width: 240,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              children: [
                // Top Box Title & Ribbon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.softRoseLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.inventory_2_rounded, size: 12, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'CURATED BOX',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.bookmark_added_rounded, size: 16, color: AppColors.softRose),
                  ],
                ),
                const Spacer(),
                // 3 Curated Creator Items inside the box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCuratedItem(
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.starGold,
                      label: 'Soy Candle',
                    ),
                    _buildCuratedItem(
                      icon: Icons.coffee_rounded,
                      color: AppColors.primary,
                      label: 'Ceramic Mug',
                    ),
                    _buildCuratedItem(
                      icon: Icons.eco_rounded,
                      color: AppColors.success,
                      label: 'Botanicals',
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),

          // Floating Tag Top Right: "Local Creators"
          Positioned(
            top: 28,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.storefront_rounded, size: 13, color: AppColors.warmCream),
                  SizedBox(width: 5),
                  Text(
                    'Local Creators',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Tag Bottom Left: "Silk Ribbon & Keepsake"
          Positioned(
            bottom: 24,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.redeem_rounded, size: 14, color: AppColors.softRose),
                  SizedBox(width: 6),
                  Text(
                    'Custom Box & Ribbon',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainText,
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

  Widget _buildCuratedItem({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Icon(icon, size: 20, color: color),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 62,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
