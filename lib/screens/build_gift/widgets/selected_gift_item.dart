import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/gift_box_model.dart';

/// Horizontal list card for a selected gift item in the current box.
class SelectedGiftItem extends StatelessWidget {
  final GiftBoxItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const SelectedGiftItem({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.all(AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            child: Container(
              width: 50,
              height: 50,
              color: AppColors.surfaceVariant,
              child: Image.network(
                item.product.imageUrls.isNotEmpty ? item.product.imageUrls.first : '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 20,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),

          // Name and Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                  CurrencyFormatter.formatPKR(item.product.price),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Quantity controls
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  key: Key('summary_decrease_${item.product.id}'),
                  onTap: onDecrement,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(AppDimensions.radiusSm),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Icon(Icons.remove, size: 14, color: AppColors.mainText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainText,
                    ),
                  ),
                ),
                InkWell(
                  key: Key('summary_increase_${item.product.id}'),
                  onTap: onIncrement,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(AppDimensions.radiusSm),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Icon(Icons.add, size: 14, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),

          // Remove Button
          IconButton(
            key: Key('summary_remove_${item.product.id}'),
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.secondaryText,
            ),
            tooltip: 'Remove',
            splashRadius: 18,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
