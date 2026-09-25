import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';

/// Placeholder screen for Cart route (/cart).
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              Expanded(
                child: EmptyState(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Your Gift Basket',
                  description: 'Placeholder for items in basket, custom gift packaging options, and recipient notes.',
                  buttonText: 'Proceed to Checkout',
                  onButtonPressed: () {
                    Navigator.pushNamed(context, AppRoutes.checkout);
                  },
                ),
              ),
              AppButton(
                text: 'Continue Shopping',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
