import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';

/// Placeholder screen for Explore route (/explore).
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              Expanded(
                child: EmptyState(
                  icon: Icons.explore_rounded,
                  title: 'Explore Marketplace',
                  description: 'Placeholder for gift categories, recipient filters, and curated artisan items.',
                  buttonText: 'View Product Details',
                  onButtonPressed: () {
                    Navigator.pushNamed(context, AppRoutes.productDetails);
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
