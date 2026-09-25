import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Clean 3-step checkout progress indicator: Basket -> Details -> Review.
class CheckoutStepIndicator extends StatelessWidget {
  final int currentStep; // 1: Details, 2: Review
  final ValueChanged<int>? onStepTapped;

  const CheckoutStepIndicator({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  static const List<String> _steps = ['Basket', 'Details', 'Review'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      child: Row(
        children: [
          Expanded(child: _buildStepItem(0, _steps[0])),
          _buildConnector(0),
          Expanded(child: _buildStepItem(1, _steps[1])),
          _buildConnector(1),
          Expanded(child: _buildStepItem(2, _steps[2])),
        ],
      ),
    );
  }

  Widget _buildConnector(int stepBefore) {
    final isPassed = currentStep > stepBefore;
    return Container(
      width: 16,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: isPassed ? AppColors.primary : AppColors.border,
    );
  }

  Widget _buildStepItem(int stepIndex, String label) {
    // Step 0 (Basket) is always completed when we are in Checkout
    final isCompleted = currentStep > stepIndex;
    final isActive = currentStep == stepIndex;

    return GestureDetector(
      onTap: onStepTapped != null ? () => onStepTapped!(stepIndex) : null,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : (isCompleted
                      ? AppColors.softRoseLight
                      : AppColors.surfaceVariant),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? AppColors.primary
                    : (isCompleted ? AppColors.softRose : AppColors.border),
                width: 1.5,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 13,
                      color: AppColors.primary,
                    )
                  : Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : AppColors.secondaryText,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppColors.mainText : AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
