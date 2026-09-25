import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../models/product_model.dart';
import '../../../services/favorites_service.dart';

/// Top product image carousel with rounded bottom corners, dots indicator,
/// back button, and persistent favorite toggle.
class ProductGallery extends StatefulWidget {
  final ProductModel product;
  final bool showOverlayNav;

  const ProductGallery({
    super.key,
    required this.product,
    this.showOverlayNav = false,
  });

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.product.imageUrls;
    final hasMultipleImages = images.length > 1;

    return Stack(
      children: [
        // Main Image / Carousel
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          child: Container(
            height: 320,
            width: double.infinity,
            color: AppColors.surfaceVariant,
            child: images.isNotEmpty
                ? PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildFallbackArt(),
                      );
                    },
                  )
                : _buildFallbackArt(),
          ),
        ),

        // Carousel Indicator Dots
        if (hasMultipleImages)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final isSelected = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isSelected ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),

        // Top Navigation Bar (Back & Favorite buttons)
        if (widget.showOverlayNav)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: AppDimensions.xs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Circular Back Button
                    _buildCircularButton(
                      key: const Key('product_details_overlay_back_button'),
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                      tooltip: 'Back',
                    ),

                    // Circular Favorite Button
                    ListenableBuilder(
                      listenable: FavoritesService.instance,
                      builder: (context, _) {
                        final isFav =
                            FavoritesService.instance.isFavorite(widget.product.id);
                        return _buildCircularButton(
                          key: const Key('product_details_overlay_favorite_button'),
                          icon: isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          iconColor: isFav ? AppColors.softRose : AppColors.darkPrimary,
                          onTap: () {
                            FavoritesService.instance.toggleFavorite(widget.product.id);
                          },
                          tooltip: isFav ? 'Remove Favorite' : 'Save to Favorites',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCircularButton({
    required Key key,
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        key: key,
        icon: Icon(
          icon,
          size: 20,
          color: iconColor ?? AppColors.darkPrimary,
        ),
        onPressed: onTap,
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildFallbackArt() {
    IconData iconData = Icons.card_giftcard_rounded;
    if (widget.product.title.contains('Mug')) iconData = Icons.coffee_rounded;
    if (widget.product.title.contains('Frame') ||
        widget.product.title.contains('Scrapbook')) {
      iconData = Icons.photo_library_outlined;
    }
    if (widget.product.title.contains('Box') ||
        widget.product.title.contains('Kit')) {
      iconData = Icons.inventory_2_outlined;
    }
    if (widget.product.title.contains('Bracelet') ||
        widget.product.title.contains('Jewelry')) {
      iconData = Icons.diamond_outlined;
    }
    if (widget.product.title.contains('Journal')) iconData = Icons.menu_book_rounded;
    if (widget.product.title.contains('Candle')) {
      iconData = Icons.local_fire_department_outlined;
    }
    if (widget.product.title.contains('Keychain')) iconData = Icons.vpn_key_outlined;

    return Container(
      decoration: const BoxDecoration(
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
          size: 64,
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
