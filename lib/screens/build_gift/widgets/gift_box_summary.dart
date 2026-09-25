import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../models/gift_box_model.dart';
import 'selected_gift_item.dart';

/// Sticky bottom summary section for the Gift Box showing selected items,
/// item counter, dynamic price calculation, and continue action.
class GiftBoxSummary extends StatefulWidget {
  final List<GiftBoxItem> items;
  final int selectedProductCount;
  final int maxProducts;
  final int minProducts;
  final double subtotal;
  final double serviceFee;
  final double total;
  final Function(String) onIncrement;
  final Function(String) onDecrement;
  final Function(String) onRemove;
  final VoidCallback onContinue;

  const GiftBoxSummary({
    super.key,
    required this.items,
    required this.selectedProductCount,
    this.maxProducts = 6,
    this.minProducts = 2,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onContinue,
  });

  @override
  State<GiftBoxSummary> createState() => _GiftBoxSummaryState();
}

class _GiftBoxSummaryState extends State<GiftBoxSummary> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasEnoughItems = widget.selectedProductCount >= widget.minProducts;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 16,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header bar (tap to toggle expanded item list)
            InkWell(
              key: const Key('toggle_gift_box_summary'),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusLg),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.lg,
                  12,
                  AppDimensions.lg,
                  10,
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
                        Icons.inventory_2_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Gift Box',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.selectedProductCount} of ${widget.maxProducts} items selected',
                            key: const Key('selection_counter_text'),
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.selectedProductCount >= widget.minProducts
                                  ? AppColors.primary
                                  : AppColors.secondaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          CurrencyFormatter.formatPKR(widget.total),
                          key: const Key('summary_total_text'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          color: AppColors.secondaryText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Expanded Items List & Subtotal Breakdown
            if (_isExpanded)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.40,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                  child: widget.items.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: EmptyState(
                            icon: Icons.card_giftcard_outlined,
                            title: 'Your gift box is empty',
                            description: "Start adding gifts they'll love.",
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 1, color: AppColors.border),
                              const SizedBox(height: AppDimensions.sm),
                              ...widget.items.map(
                                (item) => SelectedGiftItem(
                                  item: item,
                                  onIncrement: () =>
                                      widget.onIncrement(item.product.id),
                                  onDecrement: () =>
                                      widget.onDecrement(item.product.id),
                                  onRemove: () =>
                                      widget.onRemove(item.product.id),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Divider(height: 1, color: AppColors.border),
                              const SizedBox(height: 10),

                              // Subtotal Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Subtotal',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.formatPKR(widget.subtotal),
                                    key: const Key('summary_subtotal_text'),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.mainText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              // Gift Box Service Fee Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Gift box service fee',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.formatPKR(
                                        widget.serviceFee),
                                    key: const Key('summary_service_fee_text'),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.mainText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Divider(height: 1, color: AppColors.border),
                              const SizedBox(height: 6),

                              // Total Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.mainText,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.formatPKR(widget.total),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.sm),
                            ],
                          ),
                        ),
                ),
              ),

            // Continue Button Section
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.lg,
                4,
                AppDimensions.lg,
                AppDimensions.md,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  key: const Key('build_gift_continue_button'),
                  onPressed: widget.onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasEnoughItems
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.5),
                    foregroundColor: Colors.white,
                    elevation: hasEnoughItems ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          hasEnoughItems
                              ? 'Continue to Personalize'
                              : 'Choose at least 2 gifts (${widget.selectedProductCount}/2)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
