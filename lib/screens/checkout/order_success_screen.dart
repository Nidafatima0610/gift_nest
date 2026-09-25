import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

/// Screen displayed after an order is successfully placed (/order-success).
class OrderSuccessScreen extends StatefulWidget {
  final OrderModel? order;

  const OrderSuccessScreen({super.key, this.order});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Resolve order from constructor, route arguments, or order provider
    OrderModel? order = widget.order;
    if (order == null) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is OrderModel) {
        order = routeArgs;
      } else {
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        if (orderProvider.orders.isNotEmpty) {
          order = orderProvider.orders.first;
        }
      }
    }

    final orderId = order?.id ?? 'GN-DEMO-001';
    final totalAmount = order?.total ?? 0.0;
    final paymentMethod = order?.paymentMethod ?? 'Cash on Delivery';
    final deliveryCity = order?.city.isNotEmpty == true ? order!.city : 'Lahore';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Order Placed'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppDimensions.md),

                // Subtle animated Gift box celebration icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.softRoseLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '🎁',
                        style: TextStyle(fontSize: 44),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),

                // Header message
                const Text(
                  'Order placed successfully.',
                  key: Key('order_success_headline'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mainText,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                const Text(
                  'Your gift is on its way to becoming something special!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // Order details card
                AppCard(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  child: Column(
                    children: [
                      _buildInfoRow('Order ID', orderId, isBold: true),
                      const SizedBox(height: AppDimensions.sm),
                      const Divider(color: AppColors.border, height: 1),
                      const SizedBox(height: AppDimensions.sm),
                      _buildInfoRow(
                        'Total',
                        'PKR ${totalAmount.toStringAsFixed(0)}',
                        valueColor: AppColors.primary,
                        isBold: true,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      const Divider(color: AppColors.border, height: 1),
                      const SizedBox(height: AppDimensions.sm),
                      _buildInfoRow('Payment Method', paymentMethod),
                      const SizedBox(height: AppDimensions.sm),
                      const Divider(color: AppColors.border, height: 1),
                      const SizedBox(height: AppDimensions.sm),
                      _buildInfoRow('Delivery City', deliveryCity),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.md),

                // Demo note
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.warmCream,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
                      SizedBox(width: AppDimensions.sm),
                      Expanded(
                        child: Text(
                          'We have saved your order locally. You can track its status under My Orders.',
                          style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // Primary: View My Orders
                AppButton(
                  key: const Key('order_success_view_orders_button'),
                  text: 'View My Orders',
                  icon: Icons.receipt_long_outlined,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.orders);
                  },
                ),
                const SizedBox(height: AppDimensions.sm),

                // Secondary: Continue Shopping
                AppButton(
                  key: const Key('order_success_continue_shopping_button'),
                  text: 'Continue Shopping',
                  variant: AppButtonVariant.outline,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? AppColors.mainText,
          ),
        ),
      ],
    );
  }
}
