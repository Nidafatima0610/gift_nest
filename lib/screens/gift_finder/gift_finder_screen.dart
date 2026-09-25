import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';

/// Placeholder screen for Gift Finder route (/gift-finder).
class GiftFinderScreen extends StatelessWidget {
  const GiftFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gift Finder'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              Expanded(
                child: EmptyState(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Personalized Gift Finder',
                  description: 'Placeholder for step-based recommendation flow by recipient, occasion, budget, and interests.',
                  buttonText: 'Explore Gifts',
                  onButtonPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.explore);
                  },
                ),
              ),
              AppButton(
                text: 'Back to Home',
                variant: AppButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
