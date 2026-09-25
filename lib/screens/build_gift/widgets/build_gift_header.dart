import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'gift_progress_indicator.dart';

/// Top header for Build My Gift flow including title, subtitle, and step progress indicator.
class BuildGiftHeader extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  const BuildGiftHeader({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.only(
        left: AppDimensions.md,
        right: AppDimensions.md,
        top: AppDimensions.xs,
        bottom: AppDimensions.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Build My Gift',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.mainText,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Create something special, made just for them.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondaryText,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          GiftProgressIndicator(
            currentStep: currentStep,
            onStepTapped: onStepTapped,
          ),
        ],
      ),
    );
  }
}
