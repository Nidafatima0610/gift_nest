import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';

/// Placeholder screen for Build Gift route (/build-gift).
class BuildGiftScreen extends StatelessWidget {
  const BuildGiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Build Gift'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              Expanded(
                child: EmptyState(
                  icon: Icons.inventory_2_rounded,
                  title: 'Build Your Own Gift Box',
                  description: 'Placeholder for custom box selection, item curation, ribbon picking, and handwritten note flow.',
                  buttonText: 'Proceed to Cart',
                  onButtonPressed: () {
                    Navigator.pushNamed(context, AppRoutes.cart);
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
