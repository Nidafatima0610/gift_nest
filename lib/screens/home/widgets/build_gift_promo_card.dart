import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';

/// Visually distinct promotional card for "Build My Gift" feature.
class BuildGiftPromoCard extends StatelessWidget {
  const BuildGiftPromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background ambient glow accents
            Positioned(
              right: -30,
              bottom: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softRose.withValues(alpha: 0.25),
                ),
              ),
            ),
            Positioned(
              right: 40,
              top: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkPrimary.withValues(alpha: 0.5),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Boutique feature badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warmCream.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.softRose.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 13,
                          color: AppColors.softRose,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Build My Gift Box',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmCream,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.sm),

                  // Headline
                  const Text(
                    "Create a gift box that's completely yours.",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Supporting Text
                  Text(
                    'Choose the products, add a personal touch, and make it theirs.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.md),

                  // Steps preview chips
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        _buildMiniStep(context, '1', 'Choose Box'),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.softRose),
                        const SizedBox(width: 8),
                        _buildMiniStep(context, '2', 'Pick Goods'),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.softRose),
                        const SizedBox(width: 8),
                        _buildMiniStep(context, '3', 'Personalize'),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.lg),

                  // CTA Button
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      key: const Key('home_start_building_cta'),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.buildGift);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warmCream,
                        foregroundColor: AppColors.darkPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.md,
                        ),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Start Building',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkPrimary,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppColors.darkPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStep(BuildContext context, String num, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkPrimary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: AppColors.softRose,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                num,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
