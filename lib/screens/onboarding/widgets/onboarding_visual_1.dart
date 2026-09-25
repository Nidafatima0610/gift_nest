import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Boutique illustration for Onboarding Page 1: "Find a gift they'll love".
class OnboardingVisual1 extends StatelessWidget {
  const OnboardingVisual1({super.key});

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
          // Background subtle concentric decorative circles
          Positioned(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.softRoseLight.withValues(alpha: 0.5),
              ),
            ),
          ),
          Positioned(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),

          // Central Gift Box Illustration
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ribbon bow on top
              Container(
                width: 32,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.softRose,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              // Main Gift Box
              Container(
                width: 100,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Vertical ribbon
                    Container(
                      width: 18,
                      height: double.infinity,
                      color: AppColors.softRose,
                    ),
                    // Horizontal ribbon
                    Container(
                      height: 18,
                      width: double.infinity,
                      color: AppColors.softRose,
                    ),
                    // Center bow knot
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.darkPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite_rounded,
                          size: 12,
                          color: AppColors.warmCream,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Floating Tag 1: "Birthday 🎂"
          Positioned(
            top: 36,
            left: 28,
            child: _buildOccasionTag(
              icon: Icons.cake_outlined,
              label: 'Birthday',
              color: AppColors.softRose,
            ),
          ),

          // Floating Tag 2: "Anniversary ✨"
          Positioned(
            bottom: 40,
            left: 24,
            child: _buildOccasionTag(
              icon: Icons.star_border_rounded,
              label: 'Anniversary',
              color: AppColors.starGold,
            ),
          ),

          // Floating Tag 3: "Thank You 💐"
          Positioned(
            top: 50,
            right: 28,
            child: _buildOccasionTag(
              icon: Icons.spa_outlined,
              label: 'Thank You',
              color: AppColors.success,
            ),
          ),

          // Floating Tag 4: "For Her & Him"
          Positioned(
            bottom: 34,
            right: 24,
            child: _buildOccasionTag(
              icon: Icons.favorite_border_rounded,
              label: 'Just Because',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccasionTag({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.mainText,
            ),
          ),
        ],
      ),
    );
  }
}
