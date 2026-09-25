import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Clean 3-step progress indicator for the Build My Gift experience.
class GiftProgressIndicator extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  const GiftProgressIndicator({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xs,
        vertical: AppDimensions.xs,
      ),
      child: Row(
        children: [
          Expanded(child: _buildStepItem(context, 0, 'Choose Gifts')),
          _buildConnector(0),
          Expanded(child: _buildStepItem(context, 1, 'Personalize')),
          _buildConnector(1),
          Expanded(child: _buildStepItem(context, 2, 'Review')),
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

  Widget _buildStepItem(BuildContext context, int step, String label) {
    final isActive = currentStep == step;
    final isCompleted = currentStep > step;

    return InkWell(
      onTap: onStepTapped != null && step <= currentStep
          ? () => onStepTapped!(step)
          : null,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 26,
              height: 26,
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
                        size: 14,
                        color: AppColors.primary,
                      )
                    : Text(
                        '${step + 1}',
                        style: TextStyle(
                          fontSize: 11,
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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.mainText : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
