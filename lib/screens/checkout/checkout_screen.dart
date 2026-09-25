import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';

/// Placeholder screen for Checkout route (/checkout).
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              Expanded(
                child: EmptyState(
                  icon: Icons.lock_outline_rounded,
                  title: 'Checkout & Delivery',
                  description: 'Placeholder for recipient delivery address, delivery date selection, and order summary.',
                  buttonText: 'View Orders',
                  onButtonPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.orders);
                  },
                ),
              ),
              AppButton(
                text: 'Back to Cart',
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
