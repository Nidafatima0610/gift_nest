import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';

/// Visually strong hero card: "Don't know what to gift?" with CTA to /gift-finder.
class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.sm,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.warmCream,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background ambient decorative circles
            Positioned(
              right: -25,
              top: -25,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softRoseLight.withValues(alpha: 0.5),
                ),
              ),
            ),
            Positioned(
              right: 60,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLight.withValues(alpha: 0.6),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.softRoseLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 13,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'AI Gift Assistant',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.darkPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            const Text(
                              "Don't know what to gift?",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkPrimary,
                                letterSpacing: -0.3,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Tell us who it's for, the occasion and your budget. We'll help you find something special.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mainText,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: AppDimensions.md),

                      // Tasteful Gift Box visual element
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.card_giftcard_rounded,
                              size: 38,
                              color: AppColors.warmCream,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.softRose,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.md),

                  // Primary CTA Button
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      key: const Key('home_find_my_gift_cta'),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.giftFinder);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.lg,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Find My Gift',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
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
}
