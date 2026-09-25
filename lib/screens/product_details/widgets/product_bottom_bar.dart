import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/product_model.dart';
import 'quantity_selector.dart';

/// Sticky bottom action bar for Product Details screen featuring dynamic price breakdown,
/// quantity selector, validation, and Add to Cart.
class ProductBottomBar extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final Map<String, String> personalizations;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductBottomBar({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
    required this.personalizations,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  bool get _hasPersonalization => personalizations.isNotEmpty;

  double get _customizationFee =>
      (product.isCustomizable && _hasPersonalization) ? product.personalizationPrice : 0.0;

  double get _unitPrice => product.price + _customizationFee;

  double get _totalPrice => _unitPrice * quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        12,
        AppDimensions.lg,
        14,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Price Breakdown & Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price Breakdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (product.isCustomizable && _customizationFee > 0) ...[
                        Text(
                          'Base: ${CurrencyFormatter.formatPKR(product.price)} + Custom: PKR ${_customizationFee.toInt()}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Total: ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            TextSpan(
                              text: CurrencyFormatter.formatPKR(_totalPrice),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        key: const Key('product_total_price_text'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Quantity Selector
                QuantitySelector(
                  quantity: quantity,
                  onQuantityChanged: onQuantityChanged,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Row 2: Action Buttons (Add to Cart & Buy Now)
            Row(
              children: [
                // Primary CTA: Add to Cart
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    key: const Key('add_to_cart_button'),
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.warmCream,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: AppDimensions.sm),

                // Secondary CTA: Buy Now
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    key: const Key('buy_now_button'),
                    onPressed: onBuyNow,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      elevation: 0,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
