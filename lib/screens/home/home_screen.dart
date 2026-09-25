import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_title.dart';

/// Placeholder screen for Home route (/home).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                backgroundColor: AppColors.warmCream,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.sm),
                          decoration: const BoxDecoration(
                            color: AppColors.softRoseLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.card_giftcard_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.appName,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.darkPrimary,
                                    ),
                              ),
                              Text(
                                AppStrings.appTagline,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.secondaryText,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    const Text(
                      'Welcome to the Gift Nest initial foundation. You can test navigation to all registered routes below.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mainText,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.lg),

              const SectionTitle(
                title: 'Marketplace Navigation Test',
                subtitle: 'Verify all central named routes',
              ),

              const SizedBox(height: AppDimensions.sm),

              _buildRouteTile(
                context,
                title: 'Explore Gifts',
                route: AppRoutes.explore,
                icon: Icons.explore_outlined,
              ),
              _buildRouteTile(
                context,
                title: 'Gift Finder',
                route: AppRoutes.giftFinder,
                icon: Icons.auto_awesome_outlined,
              ),
              _buildRouteTile(
                context,
                title: 'Build Gift Box',
                route: AppRoutes.buildGift,
                icon: Icons.inventory_2_outlined,
              ),
              _buildRouteTile(
                context,
                title: 'Product Details',
                route: AppRoutes.productDetails,
                icon: Icons.info_outline_rounded,
              ),
              _buildRouteTile(
                context,
                title: 'Favorites',
                route: AppRoutes.favorites,
                icon: Icons.favorite_outline_rounded,
              ),
              _buildRouteTile(
                context,
                title: 'Cart',
                route: AppRoutes.cart,
                icon: Icons.shopping_bag_outlined,
              ),
              _buildRouteTile(
                context,
                title: 'Checkout',
                route: AppRoutes.checkout,
                icon: Icons.lock_outline_rounded,
              ),
              _buildRouteTile(
                context,
                title: 'Orders',
                route: AppRoutes.orders,
                icon: Icons.receipt_long_outlined,
              ),
              _buildRouteTile(
                context,
                title: 'Profile',
                route: AppRoutes.profile,
                icon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: AppDimensions.lg),

              AppButton(
                text: 'Back to Onboarding',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteTile(
    BuildContext context, {
    required String title,
    required String route,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: AppCard(
        onTap: () => Navigator.pushNamed(context, route),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainText,
                    ),
                  ),
                  Text(
                    route,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
