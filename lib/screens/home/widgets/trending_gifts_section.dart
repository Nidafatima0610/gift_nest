import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/section_title.dart';
import '../../../models/product_model.dart';
import '../data/home_demo_data.dart';

/// Horizontal list section displaying "Trending Gifts".
class TrendingGiftsSection extends StatefulWidget {
  const TrendingGiftsSection({super.key});

  @override
  State<TrendingGiftsSection> createState() => _TrendingGiftsSectionState();
}

class _TrendingGiftsSectionState extends State<TrendingGiftsSection> {
  final Set<String> _favoriteProductIds = {'prod_1', 'prod_3'};

  void _toggleFavorite(String productId) {
    setState(() {
      if (_favoriteProductIds.contains(productId)) {
        _favoriteProductIds.remove(productId);
      } else {
        _favoriteProductIds.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Trending Gifts',
          subtitle: 'Popular picks people are loving',
          actionText: 'See All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.explore),
        ),
        const SizedBox(height: AppDimensions.xs),
        SizedBox(
          height: 254,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: HomeDemoData.trendingProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.md),
            itemBuilder: (context, index) {
              final product = HomeDemoData.trendingProducts[index];
              final isFav = _favoriteProductIds.contains(product.id);

              return _ProductCardItem(
                product: product,
                isFavorite: isFav,
                onFavoriteToggle: () => _toggleFavorite(product.id),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.productDetails,
                    arguments: product.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductCardItem extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _ProductCardItem({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  IconData _getProductIcon(String categoryId) {
    switch (categoryId) {
      case 'jewelry':
        return Icons.auto_awesome_rounded;
      case 'stationery':
        return Icons.menu_book_rounded;
      case 'home_fragrance':
        return Icons.spa_rounded;
      case 'keepsakes':
        return Icons.photo_library_rounded;
      case 'care_packages':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.coffee_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('trending_product_${product.id}'),
      onTap: onTap,
      child: Container(
        width: 176,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Visual Container with Favorite Button
            Stack(
              children: [
                Container(
                  height: 122,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.warmCream,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17),
                    ),
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 0.8),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.softRoseLight.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.softRose.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        _getProductIcon(product.categoryId),
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                // Popular / Staff Pick Badge
                if (product.isPopular)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 11,
                            color: AppColors.warmCream,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Popular',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Interactive Heart / Favorite Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: Key('fav_button_${product.id}'),
                      borderRadius: BorderRadius.circular(20),
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 16,
                          color: isFavorite
                              ? AppColors.softRose
                              : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product Details Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Creator Name
                        Text(
                          product.creatorName ?? 'Local Artisan',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 2),

                        // Product Title
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainText,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),

                    // Price & Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price in PKR
                        Flexible(
                          child: Text(
                            CurrencyFormatter.format(product.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Rating badge
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppColors.starGold,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mainText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
