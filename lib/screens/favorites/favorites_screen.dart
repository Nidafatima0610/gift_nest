import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';

/// Placeholder screen for Favorites route (/favorites).
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              Expanded(
                child: EmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: 'Saved Gifts & Makers',
                  description: 'Placeholder for saved products, creator wishlists, and upcoming occasion reminders.',
                  buttonText: 'Discover Gifts',
                  onButtonPressed: () {
                    Navigator.pushNamed(context, AppRoutes.explore);
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
