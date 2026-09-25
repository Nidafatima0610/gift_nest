import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/cart_model.dart';
import '../../providers/build_gift_provider.dart';
import '../../providers/cart_provider.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_summary_card.dart';
import 'widgets/coupon_section.dart';
import 'widgets/gift_box_cart_card.dart';

/// Full shopping cart / gift basket screen.
/// Route: /cart
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide fallback CartProvider for isolated route testing
    final existingCart = Provider.of<CartProvider?>(context);
    if (existingCart == null) {
      return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: const _CartContent(),
      );
    }
    return const _CartContent();
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent();

  void _handleEditGiftBox(BuildContext context, CartItemModel item) {
    final giftBox = item.giftBox;
    if (giftBox == null) return;

    final buildProvider = Provider.of<BuildGiftProvider?>(context, listen: false);
    if (buildProvider != null) {
      buildProvider.clearGiftBox();

      // Populate build provider with existing gift box items and settings
      for (final boxItem in giftBox.items) {
        for (int i = 0; i < boxItem.quantity; i++) {
          buildProvider.addProduct(boxItem.product);
        }
      }
      buildProvider.setPackagingStyle(giftBox.packagingStyle);
      buildProvider.setPersonalMessage(giftBox.personalMessage);
      buildProvider.setPhotoPath(giftBox.photoPath);
    }

    Navigator.pushNamed(context, AppRoutes.buildGift);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: items.isEmpty
            ? _buildEmptyState(context)
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg,
                  vertical: AppDimensions.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header title & subtitle
                    const Text(
                      'Your Gift Basket',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.mainText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Everything you've picked with care.",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // Cart Items List
                    ...items.map((item) {
                      if (item.isGiftBox) {
                        return GiftBoxCartCard(
                          key: Key('cart_giftbox_${item.id}'),
                          item: item,
                          onEdit: () => _handleEditGiftBox(context, item),
                          onRemove: () => cartProvider.removeItem(item.id),
                        );
                      }
                      return CartItemCard(
                        key: Key('cart_item_${item.id}'),
                        item: item,
                        onIncrement: () {
                          cartProvider.updateQuantity(item.id, item.quantity + 1);
                        },
                        onDecrement: () {
                          if (item.quantity > 1) {
                            cartProvider.updateQuantity(item.id, item.quantity - 1);
                          }
                        },
                        onRemove: () => cartProvider.removeItem(item.id),
                      );
                    }),

                    const SizedBox(height: AppDimensions.md),

                    // Coupon Code Input Section
                    CouponSection(
                      appliedCoupon: cartProvider.appliedCoupon,
                      onApply: (code) => cartProvider.applyCoupon(code),
                      onRemove: () => cartProvider.removeCoupon(),
                    ),
                    const SizedBox(height: AppDimensions.lg),

                    // Order Summary Card
                    CartSummaryCard(
                      subtotal: cartProvider.subtotal,
                      deliveryFee: cartProvider.deliveryFee,
                      discount: cartProvider.discount,
                      total: cartProvider.total,
                      onProceed: () {
                        Navigator.pushNamed(context, AppRoutes.checkout);
                      },
                    ),
                    const SizedBox(height: AppDimensions.xl),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyState(
              icon: Icons.card_giftcard_outlined,
              title: "Your gift basket is waiting 🎁",
              description:
                  "Find something thoughtful and start building a gift they'll love.",
              buttonText: 'Explore Gifts',
              onButtonPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.explore);
              },
            ),
            const SizedBox(height: AppDimensions.sm),
            AppButton(
              key: const Key('empty_cart_build_gift_button'),
              text: 'Build a Gift Box',
              variant: AppButtonVariant.outline,
              icon: Icons.auto_awesome,
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.buildGift);
              },
            ),
          ],
        ),
      ),
    );
  }
}
