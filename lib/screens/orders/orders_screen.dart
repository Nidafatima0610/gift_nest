import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';

/// Placeholder screen for Orders route (/orders).
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              Expanded(
                child: EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'Order History & Tracking',
                  description: 'Placeholder for order status tracking, packaging updates, and digital gift receipts.',
                  buttonText: 'Back to Home',
                  onButtonPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                ),
              ),
              AppButton(
                text: 'Continue Shopping',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.explore);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
