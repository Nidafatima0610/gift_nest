import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/product_model.dart';

/// Top product metadata, pricing, badges, rating, and stock status.
class ProductInfo extends StatelessWidget {
  final ProductModel product;

  const ProductInfo({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isHandmade = product.interests.contains('Handmade') ||
        product.occasions.contains('Handmade') ||
        product.categoryId == 'handmade' ||
        product.title.toLowerCase().contains('handmade') ||
        product.description.toLowerCase().contains('handmade') ||
        product.description.toLowerCase().contains('handcrafted') ||
        (product.material != null && product.material!.toLowerCase().contains('handmade'));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges Row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (product.isCustomizable)
                _buildBadge(
                  label: 'Personalizable',
                  color: AppColors.softRose,
                  icon: Icons.auto_awesome_rounded,
                ),
              if (isHandmade)
                _buildBadge(
                  label: 'Handmade',
                  color: AppColors.primary,
                  icon: Icons.palette_outlined,
                ),
              _buildBadge(
                label: 'Gift Ready',
                color: AppColors.darkPrimary,
                icon: Icons.card_giftcard_rounded,
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.sm),

          // Product Name
          Text(
            product.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.darkPrimary,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 6),

          // Creator Name & Location
          if (product.creatorName != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'by ${product.creatorName!}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.verified_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          // Rating, Review Count, and Availability Row
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Rating Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.starGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.starGold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    '(${product.reviewCount} reviews)',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),

              // Stock Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: product.inStock
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: product.inStock ? AppColors.success : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      product.inStock ? 'In Stock · Ready to Gift' : 'Out of Stock',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: product.inStock ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Price Section
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                CurrencyFormatter.formatPKR(product.price),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              if (product.originalPrice != null)
                Text(
                  'PKR ${product.originalPrice!.toInt()}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.secondaryText,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
