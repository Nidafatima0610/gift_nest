import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Boutique illustration for Onboarding Page 2: "Make it personal".
class OnboardingVisual2 extends StatelessWidget {
  const OnboardingVisual2({super.key});

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
          // Background soft ambient glow
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softRoseLight.withValues(alpha: 0.6),
            ),
          ),

          // Layer 1: Backing Greeting Card with Ribbon
          Transform.rotate(
            angle: -0.07,
            child: Container(
              width: 170,
              height: 190,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppColors.softRoseLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.draw_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      const Icon(
                        Icons.favorite,
                        size: 14,
                        color: AppColors.softRose,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'With Love,',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkPrimary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Always yours ♡',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Mock handwritten line dividers
                  Container(
                    height: 2,
                    width: 70,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Layer 2: Front Engraved Keepsake Plaque / Photo Badge
          Transform.rotate(
            angle: 0.08,
            child: Container(
              width: 150,
              height: 160,
              margin: const EdgeInsets.only(top: 24, left: 36),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Photo / Monogram circle
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.darkPrimary,
                      border: Border.all(color: AppColors.softRose, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'S & J',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warmCream,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.softRose.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Custom Engraved',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warmCream,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Accent: Wax seal badge
          Positioned(
            bottom: 24,
            left: 36,
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
                  Icon(Icons.brush_rounded, size: 14, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Custom Names & Photos',
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
}
