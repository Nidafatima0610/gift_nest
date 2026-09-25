import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/product_model.dart';

/// Product selection card tailored for custom gift box curation.
class GiftProductSelectionCard extends StatelessWidget {
  final ProductModel product;
  final bool isSelected;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isLimitReached;

  const GiftProductSelectionCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.quantity,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
    this.isLimitReached = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Selection Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusMd - 1),
                ),
                child: AspectRatio(
                  aspectRatio: 1.25,
                  child: Container(
                    color: AppColors.surfaceVariant,
                    child: Image.network(
                      product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.secondaryText,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 12),
                        SizedBox(width: 3),
                        Text(
                          'Added',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Details & Controls
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.creatorName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        CurrencyFormatter.formatPKR(product.price),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  // Add or Quantity Controls
                  isSelected
                      ? Container(
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                key: Key('decrease_qty_${product.id}'),
                                onTap: onDecrement,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(AppDimensions.radiusSm),
                                ),
                                child: Container(
                                  width: 30,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.remove,
                                    size: 14,
                                    color: AppColors.mainText,
                                  ),
                                ),
                              ),
                              Text(
                                '$quantity',
                                key: Key('qty_text_${product.id}'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.mainText,
                                ),
                              ),
                              InkWell(
                                key: Key('increase_qty_${product.id}'),
                                onTap: onIncrement,
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(AppDimensions.radiusSm),
                                ),
                                child: Container(
                                  width: 30,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.add,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 34,
                          width: double.infinity,
                          child: OutlinedButton(
                            key: Key('add_to_box_${product.id}'),
                            onPressed: onAdd,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isLimitReached
                                    ? AppColors.border
                                    : AppColors.primary,
                                width: 1.2,
                              ),
                              foregroundColor: isLimitReached
                                  ? AppColors.secondaryText
                                  : AppColors.primary,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimensions.radiusSm),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_rounded,
                                  size: 16,
                                  color: isLimitReached
                                      ? AppColors.secondaryText
                                      : AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Add',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
