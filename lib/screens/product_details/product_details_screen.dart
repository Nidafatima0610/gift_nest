import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';

/// Placeholder screen for Product Details route (/product-details).
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              AppCard(
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: AppDimensions.borderRadiusMd,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.card_giftcard_rounded,
                          size: 48,
                          color: AppColors.softRose,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text(
                      'Boutique Artisan Gift',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Placeholder for product media, maker profile, customization options, and reviews.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Add to Cart',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
              ),
              const SizedBox(height: AppDimensions.sm),
              AppButton(
                text: 'Add to Custom Box',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.buildGift);
                },
              ),
              const SizedBox(height: AppDimensions.sm),
              AppButton(
                text: 'Back to Explore',
                variant: AppButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
