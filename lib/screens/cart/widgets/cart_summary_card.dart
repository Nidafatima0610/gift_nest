import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_button.dart';

/// Summary card displaying Subtotal, Delivery fee, Discount, Total, and Proceed button.
class CartSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final VoidCallback onProceed;

  const CartSummaryCard({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
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
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.mainText,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppDimensions.sm),

          // Subtotal Row
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Subtotal',
                  style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                ),
              ),
              Text(
                CurrencyFormatter.formatPKR(subtotal),
                key: const Key('cart_summary_subtotal'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Delivery Row
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Delivery (standard)',
                  style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                CurrencyFormatter.formatPKR(deliveryFee),
                key: const Key('cart_summary_delivery'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Discount Row (if any)
          if (discount > 0) ...[
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Discount',
                    style: TextStyle(fontSize: 13, color: AppColors.success),
                  ),
                ),
                Text(
                  '- ${CurrencyFormatter.formatPKR(discount)}',
                  key: const Key('cart_summary_discount'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),

          // Total Row
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainText,
                  ),
                ),
              ),
              Text(
                CurrencyFormatter.formatPKR(total),
                key: const Key('cart_summary_total'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),

          // Proceed to Checkout CTA
          AppButton(
            key: const Key('proceed_to_checkout_button'),
            text: 'Proceed to Checkout',
            icon: Icons.arrow_forward_rounded,
            onPressed: onProceed,
          ),
        ],
      ),
    );
  }
}
