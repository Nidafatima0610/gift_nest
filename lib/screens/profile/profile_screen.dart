import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';

/// Placeholder screen for Profile route (/profile).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              AppCard(
                backgroundColor: AppColors.warmCream,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.softRoseLight,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'hello@example.com',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.lg),

              AppCard(
                child: Column(
                  children: [
                    _buildNavTile(
                      context,
                      icon: Icons.receipt_long_outlined,
                      title: 'My Orders',
                      route: AppRoutes.orders,
                    ),
                    const Divider(),
                    _buildNavTile(
                      context,
                      icon: Icons.favorite_outline_rounded,
                      title: 'Saved Favorites',
                      route: AppRoutes.favorites,
                    ),
                    const Divider(),
                    _buildNavTile(
                      context,
                      icon: Icons.inventory_2_outlined,
                      title: 'Build Gift Box',
                      route: AppRoutes.buildGift,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.xl),

              AppButton(
                text: 'Sign Out / Back to Login',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: AppDimensions.sm),
              AppButton(
                text: 'Back to Home',
                variant: AppButtonVariant.text,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
