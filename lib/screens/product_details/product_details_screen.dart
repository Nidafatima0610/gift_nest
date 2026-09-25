import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';

import '../../core/utils/currency_formatter.dart';
import '../../models/product_model.dart';

import '../explore/data/explore_demo_data.dart';

/// Screen for Product Details route (/product-details).
/// Displays passed ProductModel if provided, or default placeholder.
class ProductDetailsScreen extends StatelessWidget {
  final ProductModel? initialProduct;

  const ProductDetailsScreen({
    super.key,
    this.initialProduct,
  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    ProductModel? routeProduct;
    if (args is ProductModel) {
      routeProduct = args;
    } else if (args is String) {
      for (final p in ExploreDemoData.catalogProducts) {
        if (p.id == args) {
          routeProduct = p;
          break;
        }
      }
    }
    final product = initialProduct ?? routeProduct;

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
                      child: Center(
                        child: Icon(
                          Icons.card_giftcard_rounded,
                          size: 48,
                          color: AppColors.softRose,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text(
                      product?.title ?? 'Boutique Artisan Gift',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkPrimary,
                          ),
                    ),
                    if (product?.creatorName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'by ${product!.creatorName}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                    if (product != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        CurrencyFormatter.formatPKR(product.price),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      product?.description ??
                          'Placeholder for product media, maker profile, customization options, and reviews.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
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
