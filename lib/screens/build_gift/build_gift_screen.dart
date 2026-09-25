import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../models/product_model.dart';
import '../../providers/build_gift_provider.dart';
import '../../providers/cart_provider.dart';
import '../explore/data/explore_demo_data.dart';
import 'widgets/build_gift_header.dart';
import 'widgets/gift_box_summary.dart';
import 'widgets/gift_message_field.dart';
import 'widgets/gift_photo_picker.dart';
import 'widgets/gift_product_selection_card.dart';
import 'widgets/gift_review_section.dart';
import 'widgets/packaging_style_selector.dart';

/// Complete Build My Gift experience where users curate custom gift boxes.
/// Route: /build-gift
class BuildGiftScreen extends StatelessWidget {
  const BuildGiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide a local BuildGiftProvider if not already available in tree
    final existingProvider = Provider.of<BuildGiftProvider?>(context);
    if (existingProvider == null) {
      return ChangeNotifierProvider(
        create: (_) => BuildGiftProvider(),
        child: const _BuildGiftContent(),
      );
    }
    return const _BuildGiftContent();
  }
}

class _BuildGiftContent extends StatelessWidget {
  const _BuildGiftContent();

  void _showLimitReachedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Gift box limit reached (maximum 6 items).',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.darkPrimary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
      ),
    );
  }

  void _showMinItemsSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Choose at least 2 gifts for your box.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
      ),
    );
  }

  void _handleContinueFromGifts(BuildContext context, BuildGiftProvider provider) {
    if (!provider.hasMinProducts) {
      _showMinItemsSnackBar(context);
      return;
    }
    provider.goToNextStep();
  }

  void _handleAddToCart(BuildContext context, BuildGiftProvider builder) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final giftBox = builder.buildGiftBox();

    cartProvider.addGiftBox(giftBox);
    builder.clearGiftBox();

    // Show polished success modal dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        contentPadding: const EdgeInsets.all(AppDimensions.lg),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: AppColors.softRoseLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.primary,
                size: 38,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            const Text(
              'Your gift box is ready 🎁',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.mainText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your curated combination of ${giftBox.items.length} items with ${giftBox.packagingStyle} packaging has been added to your cart.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            AppButton(
              key: const Key('dialog_view_cart_button'),
              text: 'View Cart',
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.pushNamed(context, AppRoutes.cart);
              },
            ),
            const SizedBox(height: AppDimensions.sm),
            AppButton(
              key: const Key('dialog_continue_shopping_button'),
              text: 'Continue Shopping',
              variant: AppButtonVariant.outline,
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final builder = Provider.of<BuildGiftProvider>(context);
    final catalogProducts = ExploreDemoData.catalogProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Build Gift'),
        actions: [
          IconButton(
            key: const Key('build_gift_cart_icon'),
            icon: const Icon(Icons.shopping_bag_outlined),
            tooltip: 'View Cart',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header with Step Indicator
            BuildGiftHeader(
              currentStep: builder.currentStep,
              onStepTapped: (step) => builder.setStep(step),
            ),

            // Step Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildCurrentStep(
                  context,
                  builder,
                  catalogProducts,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    BuildGiftProvider builder,
    List<ProductModel> catalogProducts,
  ) {
    switch (builder.currentStep) {
      case 0:
        return _buildStep1ChooseGifts(context, builder, catalogProducts);
      case 1:
        return _buildStep2Personalize(context, builder);
      case 2:
      default:
        return _buildStep3Review(context, builder);
    }
  }

  // STEP 1: CHOOSE GIFTS
  Widget _buildStep1ChooseGifts(
    BuildContext context,
    BuildGiftProvider builder,
    List<ProductModel> products,
  ) {
    return Column(
      key: const ValueKey('step_choose_gifts'),
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Warm Introductory Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.md,
                    AppDimensions.sm,
                    AppDimensions.md,
                    AppDimensions.xs,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    decoration: BoxDecoration(
                      color: AppColors.warmCream,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                      border: Border.all(color: AppColors.softRoseLight),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.card_giftcard_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Create your perfect gift box 🎁',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.mainText,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Pick a few things they'll love and make your own thoughtful combination.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Product Grid
              SliverPadding(
                padding: const EdgeInsets.all(AppDimensions.md),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      final isSelected = builder.isProductSelected(product.id);
                      final qty = builder.getProductQuantity(product.id);
                      final isLimitReached =
                          builder.isFull && !isSelected;

                      return GiftProductSelectionCard(
                        product: product,
                        isSelected: isSelected,
                        quantity: qty,
                        isLimitReached: isLimitReached,
                        onAdd: () {
                          if (isLimitReached) {
                            _showLimitReachedSnackBar(context);
                          } else {
                            builder.addProduct(product);
                          }
                        },
                        onIncrement: () {
                          builder.updateQuantity(product.id, qty + 1);
                        },
                        onDecrement: () {
                          builder.updateQuantity(product.id, qty - 1);
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Sticky Bottom Summary Bar
        GiftBoxSummary(
          items: builder.items,
          selectedProductCount: builder.selectedProductCount,
          maxProducts: BuildGiftProvider.maxProducts,
          minProducts: BuildGiftProvider.minProducts,
          subtotal: builder.subtotal,
          serviceFee: BuildGiftProvider.serviceFee,
          total: builder.total,
          onIncrement: (id) {
            final current = builder.getProductQuantity(id);
            builder.updateQuantity(id, current + 1);
          },
          onDecrement: (id) {
            final current = builder.getProductQuantity(id);
            builder.updateQuantity(id, current - 1);
          },
          onRemove: (id) => builder.removeProduct(id),
          onContinue: () => _handleContinueFromGifts(context, builder),
        ),
      ],
    );
  }

  // STEP 2: PERSONALIZE
  Widget _buildStep2Personalize(
    BuildContext context,
    BuildGiftProvider builder,
  ) {
    return Column(
      key: const ValueKey('step_personalize'),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Packaging Style Section
                PackagingStyleSelector(
                  selectedStyle: builder.packagingStyle,
                  onStyleSelected: (style) => builder.setPackagingStyle(style),
                ),
                const SizedBox(height: AppDimensions.xl),

                // Personal Message Section
                GiftMessageField(
                  initialMessage: builder.personalMessage,
                  onChanged: (msg) => builder.setPersonalMessage(msg),
                ),
                const SizedBox(height: AppDimensions.xl),

                // Photo Touch Section
                GiftPhotoPicker(
                  photoPath: builder.photoPath,
                  onPhotoChanged: (path) => builder.setPhotoPath(path),
                ),
                const SizedBox(height: AppDimensions.xl),
              ],
            ),
          ),
        ),

        // Bottom Navigation Bar
        Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AppButton(
                  text: 'Back',
                  variant: AppButtonVariant.outline,
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => builder.goToPreviousStep(),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                flex: 2,
                child: AppButton(
                  key: const Key('continue_to_review_button'),
                  text: 'Continue to Review',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => builder.goToNextStep(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 3: REVIEW
  Widget _buildStep3Review(
    BuildContext context,
    BuildGiftProvider builder,
  ) {
    return GiftReviewSection(
      key: const ValueKey('step_review'),
      items: builder.items,
      packagingStyle: builder.packagingStyle,
      personalMessage: builder.personalMessage,
      photoPath: builder.photoPath,
      subtotal: builder.subtotal,
      serviceFee: BuildGiftProvider.serviceFee,
      total: builder.total,
      onEdit: () => builder.setStep(0),
      onAddToCart: () => _handleAddToCart(context, builder),
    );
  }
}
