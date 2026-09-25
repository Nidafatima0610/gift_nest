import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../services/favorites_service.dart';
import '../explore/data/explore_demo_data.dart';
import 'widgets/creator_card.dart';
import 'widgets/customization_section.dart';
import 'widgets/delivery_card.dart';
import 'widgets/product_bottom_bar.dart';
import 'widgets/product_description_section.dart';
import 'widgets/product_gallery.dart';
import 'widgets/product_info.dart';

/// Flagship Product Details and Personalization screen (/product-details).
/// Receives a ProductModel or Product ID via route arguments.
class ProductDetailsScreen extends StatefulWidget {
  final ProductModel? initialProduct;

  const ProductDetailsScreen({
    super.key,
    this.initialProduct,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  Map<String, String> _personalizations = {};

  ProductModel _resolveProduct(BuildContext context) {
    if (widget.initialProduct != null) {
      return widget.initialProduct!;
    }

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ProductModel) {
      return args;
    } else if (args is String) {
      for (final p in ExploreDemoData.catalogProducts) {
        if (p.id == args) {
          return p;
        }
      }
    }

    return ExploreDemoData.catalogProducts.first;
  }

  bool _validatePersonalization(BuildContext context, ProductModel product) {
    if (!product.isCustomizable) {
      return true;
    }

    final hasNameField = product.customizableFields.any(
      (f) => f.toLowerCase().contains('name'),
    );
    final hasTextField = product.customizableFields.any(
      (f) => f.toLowerCase().contains('text') || f.toLowerCase().contains('initials'),
    );

    if (hasNameField) {
      final nameVal = _personalizations['Name']?.trim();
      if (nameVal == null || nameVal.isEmpty) {
        _showValidationSnackBar(
          context,
          'Please enter a name for your personalized gift ✨',
        );
        return false;
      }
    } else if (hasTextField) {
      final textVal = _personalizations['Custom Text']?.trim();
      if (textVal == null || textVal.isEmpty) {
        _showValidationSnackBar(
          context,
          'Please enter custom text for your personalized gift ✨',
        );
        return false;
      }
    }

    return true;
  }

  void _showValidationSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.warmCream,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.warmCream,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.darkPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleAddToCart(BuildContext context, ProductModel product) {
    if (!product.inStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This gift is currently out of stock.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_validatePersonalization(context, product)) {
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(
      product: product,
      quantity: _quantity,
      personalizations:
          _personalizations.isNotEmpty ? Map<String, String>.from(_personalizations) : null,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.warmCream,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added to your gift basket 🎁',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warmCream,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: AppColors.softRoseLight,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _handleBuyNow(BuildContext context, ProductModel product) {
    if (!product.inStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This gift is currently out of stock.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_validatePersonalization(context, product)) {
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(
      product: product,
      quantity: _quantity,
      personalizations:
          _personalizations.isNotEmpty ? Map<String, String>.from(_personalizations) : null,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Preparing your gift for checkout...',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.darkPrimary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );

    Navigator.pushNamed(context, AppRoutes.cart);
  }

  @override
  Widget build(BuildContext context) {
    final product = _resolveProduct(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          key: const Key('product_details_back_button'),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkPrimary),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        actions: [
          ListenableBuilder(
            listenable: FavoritesService.instance,
            builder: (context, _) {
              final isFav = FavoritesService.instance.isFavorite(product.id);
              return IconButton(
                key: const Key('product_details_favorite_button'),
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? AppColors.softRose : AppColors.darkPrimary,
                ),
                onPressed: () {
                  FavoritesService.instance.toggleFavorite(product.id);
                },
                tooltip: isFav ? 'Remove Favorite' : 'Save to Favorites',
              );
            },
          ),
          IconButton(
            key: const Key('product_details_cart_button'),
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.darkPrimary),
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductGallery(
                      product: product,
                      showOverlayNav: false,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    ProductInfo(product: product),
                    const SizedBox(height: AppDimensions.lg),
                    ProductDescriptionSection(product: product),
                    const SizedBox(height: AppDimensions.lg),
                    if (product.isCustomizable) ...[
                      CustomizationSection(
                        product: product,
                        onPersonalizationChanged: (map) {
                          setState(() {
                            _personalizations = map;
                          });
                        },
                      ),
                      const SizedBox(height: AppDimensions.lg),
                    ],
                    const DeliveryCard(),
                    const SizedBox(height: AppDimensions.lg),
                    CreatorCard(product: product),
                    const SizedBox(height: AppDimensions.xl),
                  ],
                ),
              ),
            ),
            ProductBottomBar(
              product: product,
              quantity: _quantity,
              personalizations: _personalizations,
              onQuantityChanged: (newQuantity) {
                setState(() {
                  _quantity = newQuantity;
                });
              },
              onAddToCart: () => _handleAddToCart(context, product),
              onBuyNow: () => _handleBuyNow(context, product),
            ),
          ],
        ),
      ),
    );
  }
}
