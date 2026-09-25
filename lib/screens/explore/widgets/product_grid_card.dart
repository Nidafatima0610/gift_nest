import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/product_model.dart';
import '../../../services/favorites_service.dart';

/// Boutique 2-column product card for Explore marketplace grid.
class ProductGridCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductGridCard({
    super.key,
    required this.product,
    this.onTap,
  });

  String? get _specialTag {
    if (product.isCustomizable) {
      return 'Personalizable';
    }
    if (product.interests.contains('Handmade') ||
        product.occasions.contains('Handmade') ||
        product.categoryId == 'handmade') {
      return 'Handmade';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final specialTag = _specialTag;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('product_card_${product.id}'),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: onTap ??
              () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.productDetails,
                  arguments: product,
                );
              },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Overlays
              Stack(
                children: [
                  // Image container
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusLg - 1),
                    ),
                    child: Container(
                      height: 125,
                      width: double.infinity,
                      color: AppColors.surfaceVariant,
                      child: Image.network(
                        product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildFallbackArt(product),
                      ),
                    ),
                  ),

                  // Special Tag (Personalizable / Handmade)
                  if (specialTag != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: specialTag == 'Personalizable'
                              ? AppColors.softRose
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          specialTag,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmCream,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),

                  // Favorite Button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: ListenableBuilder(
                      listenable: FavoritesService.instance,
                      builder: (context, _) {
                        final isFav = FavoritesService.instance.isFavorite(product.id);
                        return InkWell(
                          key: Key('fav_button_${product.id}'),
                          onTap: () {
                            FavoritesService.instance.toggleFavorite(product.id);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.92),
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
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 16,
                              color: isFav ? AppColors.softRose : AppColors.darkPrimary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Product Info Section
              Padding(
                padding: const EdgeInsets.all(AppDimensions.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Creator name
                    if (product.creatorName != null) ...[
                      Text(
                        product.creatorName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],

                    // Product Title
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkPrimary,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Price & Rating Row
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            CurrencyFormatter.formatPKR(product.price),
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
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            'PKR ${product.originalPrice!.toInt()}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              color: AppColors.secondaryText,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackArt(ProductModel product) {
    IconData iconData = Icons.card_giftcard_rounded;
    if (product.title.contains('Mug')) iconData = Icons.coffee_rounded;
    if (product.title.contains('Frame') || product.title.contains('Scrapbook')) {
      iconData = Icons.photo_library_outlined;
    }
    if (product.title.contains('Box') || product.title.contains('Kit')) {
      iconData = Icons.inventory_2_outlined;
    }
    if (product.title.contains('Bracelet') || product.title.contains('Jewelry')) {
      iconData = Icons.diamond_outlined;
    }
    if (product.title.contains('Journal')) iconData = Icons.menu_book_rounded;
    if (product.title.contains('Candle')) iconData = Icons.local_fire_department_outlined;
    if (product.title.contains('Keychain')) iconData = Icons.vpn_key_outlined;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warmCream,
            AppColors.surfaceVariant,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          iconData,
          size: 38,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
