import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/cart_model.dart';
import '../../../models/gift_box_model.dart';

/// Card displaying a custom-curated Gift Box line item in the shopping cart.
class GiftBoxCartCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const GiftBoxCartCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onRemove,
  });

  GiftBoxModel? get box => item.giftBox;

  @override
  Widget build(BuildContext context) {
    final giftBox = box;
    final itemsCount = giftBox?.items.length ?? 0;
    final packaging = giftBox?.packagingStyle ?? 'Classic';
    final hasNote = giftBox?.personalMessage != null && giftBox!.personalMessage!.isNotEmpty;
    final hasPhoto = giftBox?.photoPath != null && giftBox!.photoPath!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.softRose, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gift Box Badge Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.softRoseLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: AppDimensions.md),

              // Title and Badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Custom Gift Box',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainText,
                            ),
                          ),
                        ),
                        IconButton(
                          key: Key('remove_gift_box_${item.id}'),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                            color: AppColors.error,
                          ),
                          tooltip: 'Remove Gift Box',
                          splashRadius: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onRemove,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$itemsCount curated gifts included',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warmCream,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.softRoseLight),
                      ),
                      child: Text(
                        'Style: $packaging',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Message & Photo tags if provided
          if (hasNote || hasPhoto) ...[
            const SizedBox(height: AppDimensions.sm),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (hasNote)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mail_outline_rounded, size: 12, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Personal note included 💌',
                          style: TextStyle(fontSize: 11, color: AppColors.mainText),
                        ),
                      ],
                    ),
                  ),
                if (hasPhoto)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.photo_outlined, size: 12, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Keepsake memory attached',
                          style: TextStyle(fontSize: 11, color: AppColors.mainText),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],

          const SizedBox(height: AppDimensions.sm),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppDimensions.xs),

          // Price and Edit Gift Box CTA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.formatPKR(item.totalPrice),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              TextButton.icon(
                key: Key('edit_gift_box_cart_${item.id}'),
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text(
                  'Edit Gift Box',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
