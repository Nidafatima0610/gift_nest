import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../models/gift_box_model.dart';

/// Comprehensive review component displaying items, packaging, message, photo, and pricing.
class GiftReviewSection extends StatelessWidget {
  final List<GiftBoxItem> items;
  final String packagingStyle;
  final String? personalMessage;
  final String? photoPath;
  final double subtotal;
  final double serviceFee;
  final double total;
  final VoidCallback onEdit;
  final VoidCallback onAddToCart;

  const GiftReviewSection({
    super.key,
    required this.items,
    required this.packagingStyle,
    required this.personalMessage,
    required this.photoPath,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
    required this.onEdit,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Gift Box ✨',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainText,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Review your personalized combination',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                key: const Key('edit_gift_box_button'),
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text(
                  'Edit',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),

          // Packaging Style Card
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.softRoseLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
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
                      const Text(
                        'Packaging Style',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        packagingStyle,
                        key: const Key('review_packaging_style'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          // Selected Items List Card
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Selected Gifts',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainText,
                      ),
                    ),
                    Text(
                      '${items.length} items',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: AppDimensions.sm),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusSm),
                          child: Container(
                            width: 44,
                            height: 44,
                            color: AppColors.surfaceVariant,
                            child: Image.network(
                              item.product.imageUrls.isNotEmpty
                                  ? item.product.imageUrls.first
                                  : '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 18,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Qty: ${item.quantity} × ${CurrencyFormatter.formatPKR(item.product.price)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          CurrencyFormatter.formatPKR(item.totalPrice),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mainText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          // Personal Message Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.mail_outline_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Personal Message',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  personalMessage != null && personalMessage!.isNotEmpty
                      ? '"$personalMessage"'
                      : 'No personal message added.',
                  key: const Key('review_personal_message'),
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: (personalMessage != null && personalMessage!.isNotEmpty)
                        ? FontStyle.italic
                        : FontStyle.normal,
                    color: (personalMessage != null && personalMessage!.isNotEmpty)
                        ? AppColors.mainText
                        : AppColors.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          // Photo Touch Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.softRoseLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: const Icon(
                    Icons.photo_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Photo Memory',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        photoPath != null && photoPath!.isNotEmpty
                            ? '1 Keepsake Photo Attached'
                            : 'No photo memory attached',
                        key: const Key('review_photo_status'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: photoPath != null && photoPath!.isNotEmpty
                              ? AppColors.primary
                              : AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          // Price Breakdown Summary Card
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Items Subtotal',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatPKR(subtotal),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Gift box service fee',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatPKR(serviceFee),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total Price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainText,
                        ),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatPKR(total),
                      key: const Key('review_total_price'),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // CTA: Add Gift Box to Cart
          AppButton(
            key: const Key('add_gift_box_to_cart_cta'),
            text: 'Add Gift Box to Cart',
            icon: Icons.shopping_bag_outlined,
            onPressed: onAddToCart,
          ),
          const SizedBox(height: AppDimensions.sm),
          AppButton(
            text: 'Edit Gift Box',
            variant: AppButtonVariant.outline,
            onPressed: onEdit,
          ),
          const SizedBox(height: AppDimensions.md),
        ],
      ),
    );
  }
}
