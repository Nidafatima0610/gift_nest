import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Boutique increment/decrement quantity selector.
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final int maxStock;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.maxStock = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            key: const Key('quantity_decrement_button'),
            icon: Icons.remove_rounded,
            onPressed: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
            child: Text(
              '$quantity',
              key: const Key('quantity_value_text'),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.darkPrimary,
              ),
            ),
          ),
          _buildButton(
            key: const Key('quantity_increment_button'),
            icon: Icons.add_rounded,
            onPressed: quantity < maxStock ? () => onQuantityChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required Key key,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        key: key,
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 16,
          color: isEnabled ? AppColors.darkPrimary : AppColors.secondaryText.withValues(alpha: 0.35),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
